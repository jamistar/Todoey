//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jami on 2018/2/5.
//  Copyright © 2018年 Jami. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        do {
            let _ = try Realm()
            
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }

    // MARK: - Core Data stack
    



}

