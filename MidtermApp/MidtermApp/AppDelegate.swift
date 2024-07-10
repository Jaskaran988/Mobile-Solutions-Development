//
//  AppDelegate.swift
//  MidtermApp
//
//  Created by user239680 on 7/3/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  
    }
    var window: UIWindow?

      func applicationWillResignActive(_ application: UIApplication) {

          TaskDataFunctions.shared.setTasks()
      }

      func applicationDidEnterBackground(_ application: UIApplication) {
        
          TaskDataFunctions.shared.setTasks()
      }

      func applicationWillTerminate(_ application: UIApplication) {
   
          TaskDataFunctions.shared.setTasks()
      }


}

