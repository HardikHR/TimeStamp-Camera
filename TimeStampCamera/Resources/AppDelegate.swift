//
//  AppDelegate.swift
//  TimeStampCamera
//
//  Created by macOS on 06/04/22.
//

import UIKit
import DropDown
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
        Thread.sleep(forTimeInterval: 2.0)
       // Global.share d.isDateTime = UserDefaults.standard.bool(forKey: "isDatetime")
       // Global.shared.isLocation = UserDefaults.standard.bool(forKey: "isLocation")    var isFirst = false
    
        Global.shared.isFirst = true

        let DefaultPath = URL.createFolder(folderName: "Storage")
        //let Site1 = URL.createFolder(folderName: "/Storage")
        //let Site2 = URL.createFolder(folderName: "/Storage")

        var isDir : ObjCBool = false
        let fileManager = FileManager.default
        for i in [DefaultPath] {
            print(i!)
            if fileManager.fileExists(atPath: i!.path, isDirectory:&isDir) {
                print(isDir.boolValue ? "Directory exists" : "File exists")
            } else {
               _ = URL.createFolder(folderName: "Storage")
             //  _ = URL.createFolder(folderName: "/Storage/DCIM/Camera/TimeStamp/Site1")
             //  _ = URL.createFolder(folderName: "/Storage/DCIM/Camera/TimeStamp/Site2")
                print("creating directory")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}

