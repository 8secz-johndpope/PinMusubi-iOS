//
//  TransferGuideEntity.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/02.
//  Copyright © 2019 naipaka. All rights reserved.
//

public struct TransferGuideEntity: Codable {
    public var resultSet: ResultSet

    private enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }
}

public struct ResultSet: Codable {
    public var apiVersion: String
    public var engineVersion: String
    public var resourceURI: String?
    public var error: TransferGuideError?

    private enum CodingKeys: String, CodingKey {
        case apiVersion
        case engineVersion
        case resourceURI = "ResourceURI"
        case error = "Error"
    }
}

public struct TransferGuideError: Codable {
    public var code: String
    public var message: String

    private enum CodingKeys: String, CodingKey {
        case code
        case message = "Message"
    }
}
