//
//  AppDelegate.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/1/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import UIKit
import p2_OAuth2
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if(authorized()){
            let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationBar") as! NavigationBarViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return true
        }
        else {
            let viewController = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if "gitfy" == url.scheme! {
            Authorization.sharedInstance.grant.handleRedirectURL(url)
            return true
        }
        return false
    }
    
    
    private func authorized() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "authorized"){
            print("Already authorized")
            return true
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        print("1")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        print("2")
        let alert = AlertReference(reference: nil, repoName: userInfo["repo_name"] as? String, alertDescription: userInfo["description"] as? String, authorName: userInfo["author"] as? String, alertTitle: userInfo["title"] as? String, alertAction: userInfo["action"] as? String, alertDate: userInfo["date"] as? String, authorIcon: userInfo["author_icon"] as? String, alertEvent: userInfo["event"] as? String)
        if(alert.alertEvent! != "push" && alert.alertAction! != "0") {
            Store.viewContext.add(alerts: alert) { result in
                switch result {
                    case .fail(let error): print("Error: ", error)
                    case .success:
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                        print("Saved successfully")
                }
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        fullParse(userInfo)
        print("3")

        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        fullParse(userInfo)
        print("4")
        completionHandler()
    }
    
    func fullParse(_ userInfo :[AnyHashable: Any]) {
        //Full parse
        print("%@", userInfo)
        var body = ""
        var title = ""
        var msgURL = ""
        print("==============")
        
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            print("Error parsing aps")
            return
        }
        print(aps)
        
        if let alert = aps["alert"] as? String {
            body = alert
        } else if let alert = aps["alert"] as? [String : String] {
            body = alert["body"]!
            title = alert["title"]!
        }
        
        if let alert1 = aps["category"] as? String {
            msgURL = alert1
        }
        
        print(body)
        print(title)
        print(msgURL)
        
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
}

