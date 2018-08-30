//
//  AppDelegate.swift
//  FamBam Trainer
//
//  Created by Connor Ford on 8/16/18.
//  Copyright © 2018 tiagoProd. All rights reserved.
//

import UIKit
import Firebase

public var db : Firestore!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return true
    }


}

