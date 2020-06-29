//
//  AppDelegate.swift
//  HospitalFaceAI
//
//  Created by song on 2019/9/24.
//  Copyright © 2019 song. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let injectionContainer = AppDependencyContainer()
    var window: UIWindow?
    //    let barButtomApperance = UIBarButtonItem.appearance()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = injectionContainer.makeMainViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = mainVC
        return true
    }

}

