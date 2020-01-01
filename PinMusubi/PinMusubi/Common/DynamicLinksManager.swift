//
//  DynamicLinksManager.swift
//  PinMusubi
//
//  Created by rMac on 2019/12/19.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Firebase

/// Dynamic Link Manager
public class DynamicLinksManager {
    private var deepLink: URL?

    /// シェアするディープリンクを作成
    public func createShareLink(settingPoints: [SettingPointEntity], pinPoint: CLLocationCoordinate2D) {
        let urlString = "https://pinmusubi.page.link/share"
        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "settingPointsCount", value: "\(settingPoints.count)"),
            URLQueryItem(name: "pinPointLat", value: "\(pinPoint.latitude)"),
            URLQueryItem(name: "pinPointLng", value: "\(pinPoint.longitude)")
        ]

        for index in 0...settingPoints.count - 1 {
            urlComponents.queryItems?.append(URLQueryItem(name: "settingPointName\(index)", value: settingPoints[index].name))
            urlComponents.queryItems?.append(URLQueryItem(name: "settingPointLat\(index)", value: "\(settingPoints[index].latitude)"))
            urlComponents.queryItems?.append(URLQueryItem(name: "settingPointLng\(index)", value: "\(settingPoints[index].longitude)"))
        }
        guard let link = urlComponents.url else { return }

        deepLink = link
    }

    /// DynamicLinkを作成
    public func createDynamicLink(completion: @escaping (URL?) -> Void) {
        guard let link = deepLink else { return }
        let dynamicLinksDomainURIPrefix = "https://pinmusubi.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)

        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.naipaka.PinMusubiApp")
        linkBuilder?.iOSParameters?.appStoreID = "1489074206"

        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder?.socialMetaTagParameters?.title = "スポット地点の共有"
        linkBuilder?.socialMetaTagParameters?.descriptionText = "中間地点付近で良さげな場所はここだ！"

        linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true

        linkBuilder?.shorten { url, _, error in
            guard let url = url, error == nil else { return }
            print("🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️🙆‍♂️")
            print("The short URL is: \(url)")
            completion(url)
        }
    }
}
