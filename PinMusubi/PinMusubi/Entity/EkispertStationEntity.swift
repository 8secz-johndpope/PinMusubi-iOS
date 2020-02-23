//
//  EkispertStationEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/06.
//  Copyright © 2019 naipaka. All rights reserved.
//

// MARK: - EkispertStationEntity
public class EkispertStationEntity: Codable {
    public let resultSet: EkispertResultSetEntity

    public enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }

    public init(resultSet: EkispertResultSetEntity) {
        self.resultSet = resultSet
    }
}

// MARK: - ResultSet
public class EkispertResultSetEntity: Codable {
    public let apiVersion, max, offset, engineVersion: String
    public let point: PointEntity

    public enum CodingKeys: String, CodingKey {
        case apiVersion, max, offset, engineVersion
        case point = "Point"
    }

    public init(apiVersion: String, max: String, offset: String, engineVersion: String, point: PointEntity) {
        self.apiVersion = apiVersion
        self.max = max
        self.offset = offset
        self.engineVersion = engineVersion
        self.point = point
    }
}

// MARK: - Point
public class PointEntity: Codable {
    public let station: EkispertStationEntityResponse
    public let prefecture: Prefecture
    public let geoPoint: GeoPoint

    public enum CodingKeys: String, CodingKey {
        case station = "Station"
        case prefecture = "Prefecture"
        case geoPoint = "GeoPoint"
    }

    public init(station: EkispertStationEntityResponse, prefecture: Prefecture, geoPoint: GeoPoint) {
        self.station = station
        self.prefecture = prefecture
        self.geoPoint = geoPoint
    }
}

// MARK: - GeoPoint
public class GeoPoint: Codable {
    public let longi, lati, longiD, latiD: String
    public let gcs: String

    public enum CodingKeys: String, CodingKey {
        case longi, lati
        case longiD = "longi_d"
        case latiD = "lati_d"
        case gcs
    }

    public init(longi: String, lati: String, longiD: String, latiD: String, gcs: String) {
        self.longi = longi
        self.lati = lati
        self.longiD = longiD
        self.latiD = latiD
        self.gcs = gcs
    }
}

// MARK: - Prefecture
public class Prefecture: Codable {
    public let code, name: String

    public enum CodingKeys: String, CodingKey {
        case code
        case name = "Name"
    }

    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}

// MARK: - Station
public class EkispertStationEntityResponse: Codable {
    public let code, name, type, yomi: String

    public enum CodingKeys: String, CodingKey {
        case code
        case name = "Name"
        case type = "Type"
        case yomi = "Yomi"
    }

    public init(code: String, name: String, type: String, yomi: String) {
        self.code = code
        self.name = name
        self.type = type
        self.yomi = yomi
    }
}

// MARK: - EkispertStationsEntity
public class EkispertStationsEntity: Codable {
    public let resultSet: EkispertResultSets

    public enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }

    public init(resultSet: EkispertResultSets) {
        self.resultSet = resultSet
    }
}

// MARK: - ResultSets
public class EkispertResultSets: Codable {
    public let apiVersion, max, offset, engineVersion: String
    public let point: [PointEntity]

    public enum CodingKeys: String, CodingKey {
        case apiVersion, max, offset, engineVersion
        case point = "Point"
    }

    public init(apiVersion: String, max: String, offset: String, engineVersion: String, point: [PointEntity]) {
        self.apiVersion = apiVersion
        self.max = max
        self.offset = offset
        self.engineVersion = engineVersion
        self.point = point
    }
}
