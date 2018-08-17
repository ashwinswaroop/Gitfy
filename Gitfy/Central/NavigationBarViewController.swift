//
//  NavigationBarViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/3/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarViewController: UITabBarController {
                
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationPanelTabBar()
    }
    
    func initNavigationPanelTabBar(){
        
        let navigationPanelTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        navigationPanelTabBarItem1.image = UIImage.octicon(with: .repo, textColor: UIColor.lightGray, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem1.selectedImage = UIImage.octicon(with: .repo, textColor: UIColor.blue, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem1.title = "Repositories"
        
        let navigationPanelTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        navigationPanelTabBarItem2.image = UIImage.octicon(with: .alert, textColor: UIColor.lightGray, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem2.selectedImage = UIImage.octicon(with: .alert, textColor: UIColor.blue, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem2.title = "Alerts"        
        
        let navigationPanelTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        navigationPanelTabBarItem3.image = UIImage.octicon(with: .gear, textColor: UIColor.lightGray, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem3.selectedImage = UIImage.octicon(with: .gear, textColor: UIColor.blue, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem3.title = "Settings"
        //navigationPanelTabBarItem3.imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: -6, right: 0)
        
        /*
        let navigationPanelTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        navigationPanelTabBarItem4.image = UIImage.octicon(with: .gear, textColor: UIColor.lightGray, size: CGSize(width: 18, height: 18)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem4.selectedImage = UIImage.octicon(with: .gear, textColor: UIColor.blue, size: CGSize(width: 18, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationPanelTabBarItem4.title = "Settings"
        //navigationPanelTabBarItem4.imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: -6, right: 0)
         */
        
    }
    
}
