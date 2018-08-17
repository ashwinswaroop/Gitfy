//
//  Authorization.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/1/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import p2_OAuth2
import UIKit

final class Authorization {
    
    static let sharedInstance = Authorization()
    
    let grant = OAuth2CodeGrant(settings: [
        "client_id": "9d1e22930515a85ed82c",
        "client_secret": "4d2b930d62a31f4580aa3f3c922598e0422f5c52",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "redirect_uris": ["gitfy://oauth-callback"],
        "scope": "user repo:status admin:repo_hook",
        "secret_in_body": true,
        "keychain": true,
        ] as OAuth2JSON)
    
    func authorize(_ view: UIViewController, _ firstRun: Bool) {
        grant.authConfig.authorizeEmbedded = true
        grant.authConfig.authorizeContext = view
        grant.authorize() { authParameters, error in
            if let params = authParameters {
                print("Authorized! Access token is \(self.grant.accessToken!)")
                print("Authorized! Additional parameters: \(params)")
                UserDefaults.standard.set(true, forKey: "authorized")
                if firstRun {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationBar") as! NavigationBarViewController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = viewController
                        appDelegate.window?.makeKeyAndVisible()
                    }
                    self.initializeUser()
                }
            }
            else {
                print("Authorization was canceled or went wrong: \(error!)")
            }
        }
    }
    
    func initializeUser() {
        
        let base = URL(string: "https://api.github.com")!
        let url = base.appendingPathComponent("user")
        let grant = Authorization.sharedInstance.grant
        let req = grant.request(forURL: url)
        let task = grant.session.dataTask(with: req) { data, response, error in
            if let error = error {
                print(error)
            }
            else {
                let responseObject = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let userObject = responseObject as? [String: Any] {
                    if let login = userObject["login"] as? String {
                        UserDefaults.standard.set(login, forKey: "username")
                    }
                    else {
                        UserDefaults.standard.set("", forKey: "username")
                    }
                    if let name = userObject["name"] as? String {
                        UserDefaults.standard.set(name, forKey: "name")
                    }
                    else {
                        UserDefaults.standard.set("", forKey: "name")
                    }
                    if let avatar = userObject["avatar_url"] as? String {
                        UserDefaults.standard.set(avatar, forKey: "avatar")
                    }
                    else {
                        UserDefaults.standard.set("", forKey: "avatar")
                    }
                }
                UserDefaults.standard.set("off", forKey: "repo_reload")
                UserDefaults.standard.set("on", forKey: "clear_info")
                UserDefaults.standard.set("all", forKey: "filter")
            }
        }
        task.resume()
        
    }
    
    private init() {
        
    }
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

