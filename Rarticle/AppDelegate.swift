//
//  AppDelegate.swift
//  Rarticle
//
//  Created by Jamal Aartsen on 04/07/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navVC = UINavigationController()
        let coordinator = MainCoordinator()
        coordinator.navigationController = navVC
        
        window = UIWindow()
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        coordinator.start()
        return true
    }
}
