//
//  TutorialViewController.swift
//  BackGroundVideoSample
//
//  Created by rMac on 2020/02/04.
//  Copyright © 2020 naipaka. All rights reserved.
//

import AVKit
import MediaPlayer
import UIKit

internal class TutorialViewController: UIViewController {
    private var pageType: PageType?
    private var playerLayer: AVPlayerLayer?

    internal init(pageType: PageType) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = pageType
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        guard let pageType = pageType else { return }
        setDescriptionView(pageType: pageType)
        if pageType == .intoroduction {
            setBackgroundView()
            setSkipButton()
        } else if pageType == .conclusion {
            setBackgroundView()
            setCloseButton()
        } else {
            setBackgroundMovie(pageType: pageType)
            setSkipButton()
        }
    }

    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repeatMovie()
    }

    private func setBackgroundView() {
        view.backgroundColor = .white
        setTitle()
        setImage()
    }

    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.frame = view.frame
        titleLabel.text = "PinMusubi"
        titleLabel.textColor = .orange
        titleLabel.font = .boldSystemFont(ofSize: 100)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
    }

    private func setImage() {
        guard let pageType = pageType else { return }
        let image = UIImage(named: pageType.rawValue)
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
    }

    private func setBackgroundMovie(pageType: PageType) {
        // Bundle Resourcesからsample.mp4を読み込んで再生
        guard let path = Bundle.main.path(forResource: pageType.rawValue, ofType: "mov") else { return }
        let player = AVPlayer(url: URL(fileURLWithPath: path))

        player.play()

        // AVPlayer用のLayerを生成
        playerLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerLayer else { return }
        playerLayer.frame = view.frame
        let diff = (view.frame.height - 646) / 2
        playerLayer.position = CGPoint(x: view.center.x, y: view.center.y - diff)
        playerLayer.zPosition = -1
        view.layer.insertSublayer(playerLayer, at: 0)

        _ = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main) { [weak self] _ in
                self?.repeatMovie()
        }
    }

    private func repeatMovie() {
        playerLayer?.player?.seek(to: CMTime.zero)
        playerLayer?.player?.play()
    }

    private func setDescriptionView(pageType: PageType) {
        let descriptionView = UIView()
        descriptionView.frame = view.frame
        descriptionView.backgroundColor = .orange
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)

        descriptionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        descriptionView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        descriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let titleLabel = UILabel()
        titleLabel.frame = view.frame
        titleLabel.text = TutorialUtil.shared.getTutorialText(pageType: pageType).0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(titleLabel)

        titleLabel.widthAnchor.constraint(equalToConstant: descriptionView.bounds.width * 0.8).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 20).isActive = true

        let descriptionLabel = UILabel()
        descriptionLabel.frame = view.frame
        descriptionLabel.text = TutorialUtil.shared.getTutorialText(pageType: pageType).1
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.addSubview(descriptionLabel)

        descriptionLabel.widthAnchor.constraint(equalToConstant: descriptionView.bounds.width * 0.9).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }

    private func setSkipButton() {
        let skipButton = UIButton()
        skipButton.frame = view.frame
        skipButton.backgroundColor = .red
        skipButton.layer.cornerRadius = 15
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle("スキップ", for: .normal)
        skipButton.titleLabel?.font =  .systemFont(ofSize: 14)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        skipButton.layer.shadowColor = UIColor.red.cgColor
        skipButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        skipButton.layer.shadowOpacity = 0.5
        skipButton.layer.shadowRadius = 3
        view.addSubview(skipButton)

        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

    private func setCloseButton() {
        let closeButton = UIButton()
        closeButton.frame = view.frame
        closeButton.backgroundColor = .red
        closeButton.layer.cornerRadius = 15
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("スポットを探しに行く", for: .normal)
        closeButton.titleLabel?.font =  .boldSystemFont(ofSize: 20)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.layer.zPosition = 1
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.layer.shadowColor = UIColor.red.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        closeButton.layer.shadowOpacity = 0.7
        closeButton.layer.shadowRadius = 10
        view.addSubview(closeButton)

        closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 230).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }

    @objc
    private func closeView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
