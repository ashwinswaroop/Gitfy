//
//  AlertsTableViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/5/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import UIKit
import OcticonsKit
import NotificationCenter
import SafariServices

class AlertsTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    let dataSource: AlertDataSource = Store.viewContext.dataSource

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75
        UserDefaults.standard.set("all", forKey: "filter")
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dataSource.count)
        if(dataSource.count == 0) {
            return 1
        }
        else {
            return dataSource.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AlertsTableRow"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlertsTableRow  else {
            fatalError("The dequeued cell is not an instance of AlertsTableRow.")
        }
        
        cell.selectionStyle = .none
        
        if(dataSource.count == 0) {
            if(UserDefaults.standard.string(forKey: "filter")! == "all") {
                let alertDescriptionAttributed = NSMutableAttributedString(string: "Hi "+UserDefaults.standard.string(forKey: "username")!+"!"+"\n", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: "All of your alerts will appear here.", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                cell.alertDescription.attributedText = alertDescriptionAttributed
                cell.authorIcon.image = UIImage(named: "AppLogo1")
            }
            else {
                let alertDescriptionAttributed = NSMutableAttributedString(string: "Sorry "+UserDefaults.standard.string(forKey: "username")!+","+"\n", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: "No alerts of type: "+UserDefaults.standard.string(forKey: "filter")!+" are present", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                cell.alertDescription.attributedText = alertDescriptionAttributed
                cell.authorIcon.image = UIImage(named: "AppLogo1")
            }
        }
        else {
            let alertRow = dataSource.anyAlerts(at: indexPath)
            if(alertRow.alertEvent == "issue") {
                let alertDetails1 = "Issue "+alertRow.alertAction!+" by "
                let alertDetails2 = alertRow.authorName!
                let alertDetails = alertDetails1 + alertDetails2
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": "+alertRow.alertTitle!+"\n", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: alertDetails, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
            else if(alertRow.alertEvent == "push") {
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": New push"+"\n", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: alertRow.authorName!+" pushed "+alertRow.alertDescription!+" "+alertRow.alertAction!,
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
            else if(alertRow.alertEvent == "pull_request") {
                let alertDetails1 = "Pull request "+alertRow.alertAction!+" by "
                let alertDetails2 = alertRow.authorName!
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": "+alertRow.alertTitle!+"\n", attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: alertDetails1+alertDetails2,
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
            else if(alertRow.alertEvent == "fork") {
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": Forked"+"\n",
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: "Forked by "+alertRow.authorName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
            else if(alertRow.alertEvent == "star") {
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": New watcher"+"\n",
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: "Starred by "+alertRow.authorName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
            else if(alertRow.alertEvent == "release") {
                let repoNameAttributed = NSMutableAttributedString(string: alertRow.repoName!, attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)])
                let alertDescriptionAttributed = NSMutableAttributedString(string: ": "+alertRow.alertTitle!+"\n",
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.black,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)])
                let alertDetailsAttributed = NSMutableAttributedString(string: "New release published by "+alertRow.authorName!,
                    attributes:
                    [NSAttributedStringKey.foregroundColor: UIColor.darkGray,
                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
                alertDescriptionAttributed.append(alertDetailsAttributed)
                repoNameAttributed.append(alertDescriptionAttributed)
                cell.alertDescription.attributedText = repoNameAttributed
                DispatchQueue.main.async {
                    let url = URL(string: alertRow.authorIcon!)
                    let data = try? Data(contentsOf: url!)
                    cell.authorIcon.image = UIImage(data: data!)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(dataSource.count != 0) {
            return true
        }
        else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(dataSource.count != 0) {
            if (editingStyle == UITableViewCellEditingStyle.delete) {
                Store.viewContext.delete(alerts: dataSource.anyAlerts(at: indexPath)) { result in
                    switch result {
                        case .fail(let error): print("Error: ", error)
                        case .success:
                            self.loadData()
                            print("Deleted successfully")
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if(dataSource.count != 0) {
            let alertRow = dataSource.anyAlerts(at: indexPath)
            var urlString = ""
            var suffix = ""
            var prefix = ""
            let openGitHub = UIContextualAction(style: .normal, title:  "View on GitHub", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                if alertRow.alertEvent == "issue" {
                    suffix = alertRow.alertDate!
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/issues/"
                    urlString = prefix+suffix
                    print(urlString)
                }
                else if alertRow.alertEvent == "push" {
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/commits/master"
                    urlString = prefix+suffix
                }
                else if alertRow.alertEvent == "pull_request" {
                    suffix = alertRow.alertDate!
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/pulls/"
                    urlString = prefix+suffix
                    print(urlString)
                }
                else if alertRow.alertEvent == "fork" {
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/network/members"
                    urlString = prefix+suffix
                    print(urlString)
                }
                else if alertRow.alertEvent == "star" {
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/stargazers"
                    urlString = prefix+suffix
                    print(urlString)
                }
                else if alertRow.alertEvent == "release" {
                    suffix = alertRow.alertTitle!
                    prefix = "https://github.com/"+alertRow.authorName!+"/"+alertRow.repoName!+"/releases/tag/"
                    urlString = prefix+suffix
                    print(urlString)
                }
                if let url = URL(string: urlString) {
                    let vc = SFSafariViewController(url: url)
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
                success(true)
            })
            openGitHub.image = UIImage.octicon(with: .markGithub, textColor: UIColor.black, size: CGSize(width: 18, height: 18))
            return UISwipeActionsConfiguration(actions: [openGitHub])
        }
        return nil
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    @objc
    func loadData() {
        let filter = UserDefaults.standard.string(forKey: "filter")!
        if(filter != "all") {
            let predicate = NSPredicate(format: "alertEvent = %@", filter)
            dataSource.request.predicate = predicate
        }
        else {
            dataSource.request.predicate = nil
        }
        dataSource.fetch { result in
            switch result {
                case .fail(let error): print("Error: ", error)
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Fetched successfully")
            }
        }
    }
}
