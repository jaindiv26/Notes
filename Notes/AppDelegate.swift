//
//  AppDelegate.swift
//  Notes
//
//  Created by Divyansh Jain on 24/12/19.
//  Copyright © 2019 Divyansh Jain. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        var nav = UINavigationController.init()
        nav = UINavigationController.init(rootViewController: HomeViewController())
        nav.setNavigationBarHidden(false, animated: true)
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = .systemBackground
        
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

}

