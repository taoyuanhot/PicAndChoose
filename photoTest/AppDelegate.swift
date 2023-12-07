//
//  AppDelegate.swift
//  photoTest
//
//  Created by 咪咪貓 on 2023/10/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        // 檢查全域變數
//        if isBeenGuided {
//            // 如果為 true，從 ViewControllerIimgaesAnimation 開始
//            let viewControllerIimgaesAnimation = ViewControllerIimgaesAnimation() // 替換成你的實際 ViewController
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                self.window = UIWindow(windowScene: windowScene)
//                self.window?.rootViewController = viewControllerIimgaesAnimation
//                self.window?.makeKeyAndVisible()
//            }
//        } else {
//            // 如果為 false，從 ViewControllerGuilding 開始
//            let viewControllerGuilding = ViewControllerGuilding() // 替換成你的實際 ViewController
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                self.window = UIWindow(windowScene: windowScene)
//                self.window?.rootViewController = viewControllerGuilding
//                self.window?.makeKeyAndVisible()
//            }
//        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

