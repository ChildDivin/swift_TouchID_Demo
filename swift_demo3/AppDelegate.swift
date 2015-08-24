//
//  AppDelegate.swift
//  swift_demo3
//
//  Created by Tops on 5/23/15.
//  Copyright (c) 2015 Tops. All rights reserved.
//

import UIKit
 let kAppKey = "5565a2e8a3fc27d3038b47f4"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        print("------------------->Hello ")
        return true
    }
    func applicationWillResignActive(application: UIApplication) {
    }
    func applicationDidEnterBackground(application: UIApplication) {
        PushWizard.endSession()
    }
    func applicationWillEnterForeground(application: UIApplication) {
    }
    func applicationDidBecomeActive(application: UIApplication) {
    }
    func applicationWillTerminate(application: UIApplication) {
    }
    //MARK: Get Device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        println(deviceToken)
        PushWizard .startWithToken(deviceToken, andAppKey: kAppKey, andValues:nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println(error)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
       // application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PushWizard.handleNotification(userInfo)
        var state: UIApplicationState = application.applicationState
        if state == UIApplicationState.Active {
            
            println(userInfo)
            println(userInfo["aps"])
            var alert2 = UIAlertController(title: userInfo["t"] as? String, message:"", preferredStyle: UIAlertControllerStyle.Alert)
            alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            }))
            
            self.window?.rootViewController?.presentViewController(alert2, animated: true, completion: nil)
            
        }

    }
}
//{
//    aps =     {
//        alert =         {
//            "action-loc-key" = OK;
//            body = "Happy birthday ...";
//        };
//        badge = 1;
//        sound = default;
//        };
//        t = BDate;
//        v0 = zero;
//        v1 = one;
//        v2 = Two;
//}
