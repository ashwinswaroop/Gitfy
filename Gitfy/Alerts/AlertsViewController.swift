//
//  AlertsViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/11/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import UIKit

class AlertsViewController: UIViewController {
    
    @IBOutlet weak var filterIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        filterIcon.addGestureRecognizer(tapGesture)
        filterIcon.isUserInteractionEnabled = true
        filterIcon.image = UIImage.octicon(with: .settings, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
    }
    
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {

        if (gesture.view as? UIImageView) != nil {
            
            let alertController = UIAlertController(title: nil, message: "Choose the alert type to filter by", preferredStyle: .actionSheet)
            
            let all = UIAlertAction(title: "All", style: .default, handler: { (action) -> Void in
                print("All")
                UserDefaults.standard.set("all", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let issues = UIAlertAction(title: "Issues", style: .default, handler: { (action) -> Void in
                print("Issues")
                UserDefaults.standard.set("issue", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let pushes = UIAlertAction(title: "Pushes", style: .default, handler: { (action) -> Void in
                print("Pushes")
                UserDefaults.standard.set("push", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let pullRequests = UIAlertAction(title: "Pull Requests", style: .default, handler: { (action) -> Void in
                print("Pull requests")
                UserDefaults.standard.set("pull_request", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let forks = UIAlertAction(title: "Forks", style: .default, handler: { (action) -> Void in
                print("Forks")
                UserDefaults.standard.set("fork", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let stars = UIAlertAction(title: "Stars", style: .default, handler: { (action) -> Void in
                print("stars")
                UserDefaults.standard.set("star", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let releases = UIAlertAction(title: "Releases", style: .default, handler: { (action) -> Void in
                print("releases")
                UserDefaults.standard.set("release", forKey: "filter")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
            })
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            alertController.addAction(all)
            alertController.addAction(issues)
            alertController.addAction(pushes)
            alertController.addAction(pullRequests)
            alertController.addAction(forks)
            alertController.addAction(stars)
            alertController.addAction(releases)
            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
}
