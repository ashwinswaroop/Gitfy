//
//  RepositoriesTableViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/1/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation

import UIKit
import OcticonsKit
import FirebaseMessaging

class RepositoriesTableViewController: UITableViewController {
    
    var repositories = [Repository]()
    var collapse = [Int]()
    //let repoInfoSize = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(UserDefaults.standard.string(forKey: "repo_reload")=="on") {
            loadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collapse[section]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var rowNumber = indexPath.row
        
        for i in 0..<indexPath.section {
            rowNumber += self.tableView.numberOfRows(inSection: i)
        }

        let cellIdentifier = "RepositoriesTableRow"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepositoriesTableRow  else {
                fatalError("The dequeued cell is not an instance of RepositoriesTableRow.")
        }
        
        var text: String
        var icon: UIImage
        cell.selectionStyle = .none
        cell.accessoryType = .none
        switch indexPath.row%6 {
            case 0:
                if(repositories[rowNumber/6].forks == 1) {
                    text = String(repositories[rowNumber/6].forks)+" fork"
                }
                else {
                    text = String(repositories[rowNumber/6].forks)+" forks"
                }
                icon = UIImage.octicon(with: .repoForked, textColor: UIColor.green, size: CGSize(width: 18, height: 18))
            case 1:
                if(repositories[rowNumber/6].issues == 1) {
                    text = String(repositories[rowNumber/6].issues)+" open issue"
                }
                else {
                    text = String(repositories[rowNumber/6].issues)+" open issues"
                }
                icon = UIImage.octicon(with: .issueOpened, textColor: UIColor.red, size: CGSize(width: 18, height: 18))
            case 2:
                if(repositories[rowNumber/6].watchers == 1) {
                    text = String(repositories[rowNumber/6].watchers)+" watcher"
                }
                else {
                    text = String(repositories[rowNumber/6].watchers)+" watchers"
                }
                icon = UIImage.octicon(with: .eye, textColor: UIColor.blue, size: CGSize(width: 18, height: 18))
            case 3:
                if(repositories[rowNumber/6].stargazers == 1) {
                    text = String(repositories[rowNumber/6].stargazers)+" star"
                }
                else {
                    text = String(repositories[rowNumber/6].stargazers)+" stars"
                }
                icon = UIImage.octicon(with: .star, textColor: UIColor.yellow, size: CGSize(width: 18, height: 18))
            case 4:
                text = "Created on: "+String(repositories[rowNumber/6].created).prefix(10)
                icon = UIImage.octicon(with: .history, textColor: UIColor.orange, size: CGSize(width: 18, height: 18))
            case 5:
                //cell.selectionStyle = .default
                cell.accessoryType = .disclosureIndicator
                if UserDefaults.standard.bool(forKey: repositories[indexPath.section].name) {
                    text = "Push alerts are enabled. Touch to disable."
                }
                else {
                    text = "Push alerts are disabled. Touch to enable."
                }
                icon = UIImage.octicon(with: .desktopDownload, textColor: UIColor.black, size: CGSize(width: 18, height: 18))
            default:
                text = "Error"
                icon = UIImage.octicon(with: .bug, textColor: UIColor.black, size: CGSize(width: 18, height: 18))
        }
        
        cell.rowValue.text = text
        cell.rowIcon.image = icon
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UITableViewCell? {
        
        guard let header = tableView.dequeueReusableCell(withIdentifier: "RepositoriesTableHeader") as? RepositoriesTableHeader
            else {
                fatalError("The dequeued cell is not an instance of RepositoriesTableHeader.")
            }
        
        header.repositoryName.text = String(self.repositories[section].name.dropFirst(19))
        if let repoDesc =  self.repositories[section].description {
            header.repositoryDescription.text = repoDesc
        }
        else {
            header.repositoryDescription.text = "(no description)"
        }
        header.accessoryType = .disclosureIndicator
        let singleTap = GitfyTapGestureRecognizer(target: self, action: #selector(self.tapDetected))
        singleTap.section = section
        singleTap.numberOfTouchesRequired = 1
        singleTap.numberOfTapsRequired = 1
        header.addGestureRecognizer(singleTap)
        return header;
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        if indexPath.row%6 == 5 && !UserDefaults.standard.bool(forKey: repositories[indexPath.section].name) {
            let alert = UIAlertController(title: "Enable push notifications for this repository?", message: "This will create a webhook in the chosen repository to notify you when certain events occur", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                //self.createWebhook(String(self.repositories[indexPath.section].name.dropFirst(19)))
                self.createWebhook(String(self.repositories[indexPath.section].name.dropFirst(19)))
                print("Webhook created")
                UserDefaults.standard.set(true, forKey: self.repositories[indexPath.section].name)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
                print("Webhook creation cancelled")
            }))
            self.present(alert, animated: true)
        }
        if indexPath.row%6 == 5 && UserDefaults.standard.bool(forKey: repositories[indexPath.section].name) {
            let alert = UIAlertController(title: "Disable push notifications for this repository?", message: "This will remove the webhook associated with the chosen repository", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.deleteWebhook(String(self.repositories[indexPath.section].name.dropFirst(19)))
                UserDefaults.standard.set(false, forKey: self.repositories[indexPath.section].name)
                print("Webhook removed")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {action in
                print("Webhook removal cancelled")
            }))
            self.present(alert, animated: true)
        }
    }
    
    func loadData() {
        Authorization.sharedInstance.authorize(self, false)
        let base = URL(string: "https://api.github.com")!
        let url = base.appendingPathComponent("user/repos")
        let grant = Authorization.sharedInstance.grant
        let req = grant.request(forURL: url)
        let task = grant.session.dataTask(with: req) { data, response, error in
            if let error = error {
                print(error)
            }
            else {
                let responseObject = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = responseObject as? [Any] {
                    for object in array {
                        if let item = object as? [String: Any]{
                            
                            self.repositories.append(Repository(item["html_url"] as! String, item["description"] as? String, item["created_at"] as! String, item["open_issues_count"] as! Int, item["forks_count"] as! Int, item["watchers_count"] as! Int, item["stargazers_count"] as! Int))
                            
                        }
                    }
                }
                if(self.repositories.count > 0) {
                    for _ in 1...self.repositories.count  {
                        self.collapse.append(0)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func createWebhook(_ owner_repo: String) {
        
        let tokenId: String = Messaging.messaging().fcmToken!
        let json: [String: Any] = [
            "name": "web",
            "active": true,
            "events": [
            "push",
            "pull_request",
            "issues",
            "fork",
            "watch",
            "release"
            ],
            "config": [
                "url": "https://us-central1-gitfy-c0eb1.cloudfunctions.net/notify?tokenId=\(tokenId)",
                "content_type": "json"
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        Authorization.sharedInstance.authorize(self, false)
        let base = URL(string: "https://api.github.com")!
        let url = base.appendingPathComponent("/repos/"+owner_repo+"/hooks")
        let grant = Authorization.sharedInstance.grant
        var req = grant.request(forURL: url)
        req.httpMethod = "POST"
        req.httpBody = jsonData
        let task = grant.session.dataTask(with: req) { data, response, error in
            if let error = error {
                print(error)
            }
            else {
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    if let id = responseJSON["id"] as? Int {
                        UserDefaults.standard.set(String(id), forKey: owner_repo+"_hook")
                    }
                }
            }
        }
        task.resume()
    }
    
    func deleteWebhook(_ owner_repo: String) {
        Authorization.sharedInstance.authorize(self, false)
        var webhookId = UserDefaults.standard.string(forKey: owner_repo+"_hook")
        if(webhookId == nil){
            webhookId = "1"
        }
        print(webhookId!)
        let base = URL(string: "https://api.github.com")!
        let url = base.appendingPathComponent("/repos/"+owner_repo+"/hooks/"+webhookId!)
        let grant = Authorization.sharedInstance.grant
        var req = grant.request(forURL: url)
        req.httpMethod = "DELETE"
        let task = grant.session.dataTask(with: req) { data, response, error in
            if let error = error {
                print(error)
            }
            else {
                print(response!)
            }
        }
        task.resume()
    }
    
    @objc func tapDetected(recognizer: GitfyTapGestureRecognizer) {
        print(recognizer.section)
        let status = self.collapse[recognizer.section]
        if(status==0) {
            self.collapse[recognizer.section] = 6
        }
        else if(status==6) {
            self.collapse[recognizer.section] = 0
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

class GitfyTapGestureRecognizer: UITapGestureRecognizer {
    var section = -1
}

