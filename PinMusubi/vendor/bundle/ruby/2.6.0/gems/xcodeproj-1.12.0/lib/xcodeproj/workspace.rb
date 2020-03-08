require 'fileutils'
require 'rexml/document'
require 'xcodeproj/workspace/file_reference'
require 'xcodeproj/workspace/group_reference'

module Xcodeproj
  # Provides support for generating, reading and serializing Xcode Workspace
  # documents.
  #
  class Workspace
    # @return [REXML::Document] the parsed XML model for the workspace contents
    attr_reader :document

    # @return [Hash<String => String>] a mapping from scheme name to project full path
    #         containing the scheme
    attr_reader :schemes

    # @return [Array<FileReference>] the paths of the projects contained in the
    #         workspace.
    #
    def file_references
      return [] unless @document
      @document.get_elements('/Workspace//FileRef').map do |node|
        FileReference.from_node(node)
      end
    end

    # @return [Array<GroupReference>] the groups contained in the workspace
    #
    def group_references
      return [] unless @document
      @document.get_elements('/Workspace//Group').map do |node|
        GroupReference.from_node(node)
      end
    end

    # @param [REXML::Document] document @see document
    # @param [Array<FileReference>] file_references additional projects to add
    #
    # @note The document parameter is passed to the << operator if it is not a
    #       valid REXML::Document. It is optional, but may also be passed as nil
    #
    def initialize(document, *file_references)
      @schemes = {}
      if document.nil?
        @document = REXML::Document.new(root_xml(''))
      elsif document.is_a?(REXML::Document)
        @document = document
      else
        @document = REXML::Document.new(root_xml(''))
        self << document
      end
      file_references.each { |ref| self << ref }
    end

    #-------------------------------------------------------------------------#

    # Returns a workspace generated by reading the contents of the given path.
    #
    # @param  [String] path
    #         the path of the `xcworkspace` file.
    #
    # @return [Workspace] the generated workspace.
    #
    def self.new_from_xcworkspace(path)
      from_s(File.read(File.join(path, 'contents.xcworkspacedata')),
             File.expand_path(path))
    rescue Errno::ENOENT
      new(nil)
    end

    #-------------------------------------------------------------------------#

    # Returns a workspace generated by reading the contents of the given
    # XML representation.
    #
    # @param  [String] xml
    #         the XML representation of the workspace.
    #
    # @return [Workspace] the generated workspace.
    #
    def self.from_s(xml, workspace_path = '')
      document = REXML::Document.new(xml)
      instance = new(document)
      instance.load_schemes(workspace_path)
      instance
    end

    # Adds a new path to the list of the of projects contained in the
    # workspace.
    # @param [String, Xcodeproj::Workspace::FileReference] path_or_reference
    #        A string or Xcode::Workspace::FileReference containing a path to an Xcode project
    #
    # @raise [ArgumentError] Raised if the input is neither a String nor a FileReference
    #
    # @return [void]
    #
    def <<(path_or_reference)
      return unless @document && @document.respond_to?(:root)

      case path_or_reference
      when String
        project_file_reference = Xcodeproj::Workspace::FileReference.new(path_or_reference)
      when Xcodeproj::Workspace::FileReference
        project_file_reference = path_or_reference
        projpath = nil
      else
        raise ArgumentError, "Input to the << operator must be a file path or FileReference, got #{path_or_reference.inspect}"
      end

      @document.root.add_element(project_file_reference.to_node)
      load_schemes_from_project File.expand_path(projpath || project_file_reference.path)
    end

    #-------------------------------------------------------------------------#

    # Adds a new group container to the workspace
    # workspace.
    #
    # @param  [String] name The name of the group
    #
    # @yield [Xcodeproj::Workspace::GroupReference, REXML::Element]
    #        Yields the GroupReference and underlying XML element for mutation
    #
    # @return [Xcodeproj::Workspace::GroupReference] The added group reference
    #
    def add_group(name)
      return nil unless @document
      group = Xcodeproj::Workspace::GroupReference.new(name)
      elem = @document.root.add_element(group.to_node)
      yield group, elem if block_given?
      group
    end

    # Checks if the workspace contains the project with the given file
    # reference.
    #
    # @param  [FileReference] file_reference
    #         The file_reference to the project.
    #
    # @return [Boolean] whether the project is contained in the workspace.
    #
    def include?(file_reference)
      file_references.include?(file_reference)
    end

    # @return [String] the XML representation of the workspace.
    #
    def to_s
      contents = ''
      stack = []
      @document.root.each_recursive do |elem|
        until stack.empty?
          last = stack.last
          break if last == elem.parent
          contents += xcworkspace_element_end_xml(stack.length, last)
          stack.pop
        end

        stack << elem
        contents += xcworkspace_element_start_xml(stack.length, elem)
      end

      until stack.empty?
        contents += xcworkspace_element_end_xml(stack.length, stack.last)
        stack.pop
      end

      root_xml(contents)
    end

    # Saves the workspace at the given `xcworkspace` path.
    #
    # @param  [String] path
    #         the path where to save the project.
    #
    # @return [void]
    #
    def save_as(path)
      FileUtils.mkdir_p(path)
      File.open(File.join(path, 'contents.xcworkspacedata'), 'w') do |out|
        out << to_s
      end
    end

    #-------------------------------------------------------------------------#

    # Load all schemes from all projects in workspace or in the workspace container itself
    #
    # @param [String] workspace_dir_path
    #         path of workspaces dir
    #
    # @return [void]
    #
    def load_schemes(workspace_dir_path)
      # Normalizes path to directory of workspace needed for file_reference.absolute_path
      workspaces_dir = workspace_dir_path
      if File.extname(workspace_dir_path) == '.xcworkspace'
        workspaces_dir = File.expand_path('..', workspaces_dir)
      end

      file_references.each do |file_reference|
        project_full_path = file_reference.absolute_path(workspaces_dir)
        load_schemes_from_project(project_full_path)
      end

      # Load schemes that are in the workspace container.
      workspace_abs_path = File.absolute_path(workspace_dir_path)
      Dir[File.join(workspace_dir_path, 'xcshareddata', 'xcschemes', '*.xcscheme')].each do |scheme|
        scheme_name = File.basename(scheme, '.xcscheme')
        @schemes[scheme_name] = workspace_abs_path
      end
    end

    private

    # Load all schemes from project
    #
    # @param [String] project_full_path
    #         project full path
    #
    # @return [void]
    #
    def load_schemes_from_project(project_full_path)
      schemes = Xcodeproj::Project.schemes project_full_path
      schemes.each do |scheme_name|
        @schemes[scheme_name] = project_full_path
      end
    end

    # @return [String] The template of the workspace XML as formated by Xcode.
    #
    # @param  [String] contents The XML contents of the workspace.
    #
    def root_xml(contents)
      <<-DOC
<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
#{contents.rstrip}
</Workspace>
DOC
    end

    #
    # @param  [Integer] depth The depth of the element in the tree
    # @param  [REXML::Document::Element] elem The XML element to format.
    #
    # @return [String] The Xcode-specific XML formatting of an element start
    #
    def xcworkspace_element_start_xml(depth, elem)
      attributes = case elem.name
                   when 'Group'
                     %w(location name)
                   when 'FileRef'
                     %w(location)
                   end
      contents = "<#{elem.name}"
      indent = '   ' * depth
      attributes.each { |name| contents += "\n   #{name} = \"#{elem.attribute(name)}\"" }
      contents.split("\n").map { |line| "#{indent}#{line}" }.join("\n") + ">\n"
    end

    #
    # @param  [Integer] depth The depth of the element in the tree
    # @param  [REXML::Document::Element] elem The XML element to format.
    #
    # @return [String] The Xcode-specific XML formatting of an element end
    #
    def xcworkspace_element_end_xml(depth, elem)
      "#{'   ' * depth}</#{elem.name}>\n"
    end

    #-------------------------------------------------------------------------#
  end
end
