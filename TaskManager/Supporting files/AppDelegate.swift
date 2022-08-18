//
//  AppDelegate.swift
//  TaskManager
//
//  Created by vbugrym on 26.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
        let taskVC = TaskViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: taskVC)
        window?.makeKeyAndVisible()
        
        return true
    }
}

