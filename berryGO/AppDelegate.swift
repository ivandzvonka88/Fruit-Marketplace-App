//
//  AppDelegate.swift
//  berryGO
//
//  Created by Evgeny Gusev on 12.11.2019.
//  Copyright © 2019 DATA5 CORP. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let userDataChanged = Notification.Name(rawValue: "userDataChanged")
    static let fruitsDataChanged = Notification.Name(rawValue: "fruitsDataChanged")
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        UserManager.loadLikedFruits()
        let mapViewController = MapViewController.instantiate(fromStoryboard: "Main")
        let navigationController = UINavigationController(rootViewController: mapViewController)
        navigationController.navigationBar.isHidden = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}
