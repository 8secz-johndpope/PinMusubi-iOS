//
//  AppDelegate.swift
//  PinMusubi
//
//  Created by rMac on 2019/08/12.
//  Copyright © 2019 naipaka. All rights reserved.
//

import CoreLocation
import Firebase
import RealmSwift
import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TabBar
        if let tabVC = window?.rootViewController as? UITabBarController {
            tabVC.selectedIndex = 1
            tabVC.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
            tabVC.tabBar.layer.shadowColor = UIColor.gray.cgColor
            tabVC.tabBar.layer.shadowRadius = 4.0
            tabVC.tabBar.layer.shadowOpacity = 0.6
        }

        // Realm
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 2 {}
            }
        )
        Realm.Configuration.defaultConfiguration = config

        // Firebase
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["5a5d77ef1e172802b323f5433e396dbe"]

        return true
    }

    /// アプリがインストールされている時にURLから飛んできた時の処理
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let webpageURL = userActivity.webpageURL else { return false }
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL) { dynamiclink, _ in
            guard let link = dynamiclink?.url else { return }
            self.setParameter(deepLink: link)
        }
        return handled
    }

    private func setParameter(deepLink: URL) {
        var pinPoint = CLLocationCoordinate2D()
        var settingPoints = [SettingPointEntity]()

        guard let settingPointsCountString = deepLink.queryValue(for: "settingPointsCount") else { return }
        guard let pinPointLatString = deepLink.queryValue(for: "pinPointLat") else { return }
        guard let pinPointLngString = deepLink.queryValue(for: "pinPointLng") else { return }

        guard let settingPointsCount = Int(settingPointsCountString) else { return }
        guard let pinPointLat = CLLocationDegrees(pinPointLatString) else { return }
        guard let pinPointLng = CLLocationDegrees(pinPointLngString) else { return }

        pinPoint = CLLocationCoordinate2D(latitude: pinPointLat, longitude: pinPointLng)

        for index in 0...settingPointsCount - 1 {
            let settingPoint = SettingPointEntity()

            guard let settingPointLatString = deepLink.queryValue(for: "settingPointLat\(index)") else { return }
            guard let settingPointLngString = deepLink.queryValue(for: "settingPointLng\(index)") else { return }
            guard let settingPointLat = CLLocationDegrees(settingPointLatString) else { return }
            guard let settingPointLng = CLLocationDegrees(settingPointLngString) else { return }

            // なぜかsettingPointNameがnilになる時があるので、応急処置としてnilだった場合は緯度経度から場所名を取得するようにする。
            // settingPointNameはインスタンス生成された時点でnilは許容しないはずなのに。
            if let settingPointName = deepLink.queryValue(for: "settingPointName\(index)") {
                settingPoint.name = settingPointName
            } else {
                SearchInterestPlaceModel().getAddress(point: CLLocationCoordinate2D(latitude: settingPointLat, longitude: settingPointLng)) { address, _ in
                    settingPoint.name = address
                }
            }

            settingPoint.latitude = settingPointLat
            settingPoint.longitude = settingPointLng

            settingPoints.append(settingPoint)
        }

        /// シェアされた場所をマップに表示
        if let tabVC = window?.rootViewController as? UITabBarController {
            tabVC.selectedIndex = 1
            if let searchInterestPlaceVC = tabVC.selectedViewController as? SearchInterestPlaceViewController {
                searchInterestPlaceVC.setPin(settingPoints: settingPoints, halfwayPoint: pinPoint)
                searchInterestPlaceVC.moveFloatingPanel(position: .tip)
            }
        }
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: ""
        )
    }

    /// アプリがインストールされていない時にURLから飛んできた時の処理
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            guard let link = dynamicLink.url else { return false }
            print("🙋‍♂️🙋‍♂️🙋‍♂️🙋‍♂️🙋‍♂️🙋‍♂️🙋‍♂️🙋‍♂️")
            print("アプリがインストールされていない")
            print(link)
            return true
        }
        return false
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or S
        // MS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    public func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
