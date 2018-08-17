//
//  LoginViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/1/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import UIKit
import p2_OAuth2

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var githubLogo1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoginButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLoginButton() {
        
        let radius: CGFloat = 20, dimension: CGFloat = 125, offset = 8
        let imageView = githubLogo1!
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        let roundedView = UIView()
        roundedView.layer.shadowColor = UIColor.darkGray.cgColor
        roundedView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: dimension, height: dimension), cornerRadius: radius).cgPath
        roundedView.layer.shadowOffset = CGSize(width: offset, height: offset)
        roundedView.layer.shadowOpacity = 0.8
        roundedView.layer.shadowRadius = 2
        roundedView.addSubview(imageView)
        view.addSubview(roundedView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.widthAnchor.constraint(equalToConstant: dimension).isActive = true
        roundedView.heightAnchor.constraint(equalToConstant: dimension).isActive = true
        imageView.widthAnchor.constraint(equalTo: roundedView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: roundedView.heightAnchor).isActive = true
        roundedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roundedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: roundedView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor).isActive = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        githubLogo1!.isUserInteractionEnabled = true
        githubLogo1!.addGestureRecognizer(singleTap)
        
    }
    
    @objc func tapDetected() {
        Authorization.sharedInstance.authorize(self, true)
    }
    
}

