//
//  AppDelegate.swift
//  Good Ones
//
//  Created by Ráfagan Abreu on 16/05/22.
//

import UIKit
import GPhotos

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configGPhotos()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let gphotosHandled = GPhotos.continueAuthorizationFlow(with: url)
        return gphotosHandled
    }
    
    func configGPhotos() {
        var config = Config()
        config.printLogs = false
        GPhotos.initialize(with: config)
    }
}
