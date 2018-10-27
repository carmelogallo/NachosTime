//
//  AppDelegate.swift
//  PopcornTime
//
//  Created by Carmelo Gallo on 28/09/2018.
//  Copyright © 2018 Carmelo Gallo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if DEBUG
        if let _ = NSClassFromString("XCTest") {
            // If we're running tests, don't launch the main storyboard as
            // it's confusing if that is running fetching content whilst the
            // tests are also doing so.
            let viewController = UIViewController()
            let label = UILabel()
            label.text = "Running tests..."
            label.frame = viewController.view.frame
            label.textAlignment = .center
            label.textColor = .white
            viewController.view.addSubview(label)
            self.window?.rootViewController = viewController
            return true
        }
        #endif
        
        let vc = SplashScreenViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }

}
