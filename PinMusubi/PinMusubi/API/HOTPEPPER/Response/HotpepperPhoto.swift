//
//  HotpepperPhoto.swift
//  PinMusubi
//
//  Created by rMac on 2020/02/20.
//  Copyright © 2020 naipaka. All rights reserved.
//

// MARK: - HotpepperPhoto
struct HotpepperPhoto: Decodable {
    let pc: HotpepperPcPhoto
    let mobile: HotpepperMobilePhoto

    // MARK: - HotpepperPcPhoto
    struct HotpepperPcPhoto: Decodable {
        let l: String
        let m: String
        let s: String
    }

    // MARK: - HotpepperMobilePhoto
    struct HotpepperMobilePhoto: Decodable {
        let l: String
        let s: String
    }
}
