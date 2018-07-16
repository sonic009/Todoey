//
//  AppDelegate.swift
//  Todoey
//
//  Created by AshwaniKumar on 06/07/18.
//  Copyright © 2018 Ashwani Kumar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //getting realm database file path..
        print(Realm.Configuration.defaultConfiguration.fileURL!)


    do {
        _ = try Realm()
    }catch {
        print("Error initialising new Realm, \(error)")
    }

        
//        //We are just printing the path in console to verify userDefaults data path..
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        
        return true
    }
}
