//
//  SettingsTableViewController.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/10/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import UIKit
import CoreData
import SafariServices

class SettingsTableViewController: UITableViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellIdentifier = "SettingsTableHeader"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableHeader  else {
                fatalError("The dequeued cell is not an instance of SettingsTableHeader.")
            }
            cell.selectionStyle = .none
            cell.username.text = "Signed in as "+UserDefaults.standard.string(forKey: "username")!
            DispatchQueue.main.async {
                let url = URL(string: UserDefaults.standard.string(forKey: "avatar")!)
                let data = try? Data(contentsOf: url!)
                cell.avatar.image = UIImage(data: data!)
            }
            return cell
        }
        else {
            let cellIdentifier = "SettingsTableRow"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SettingsTableRow  else {
                fatalError("The dequeued cell is not an instance of SettingsTableRow.")
            }
            cell.selectionStyle = .none
            if indexPath.row == 1 {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(true, animated: true)
                switchView.addTarget(self, action: #selector(self.clearInfo), for: .valueChanged)
                cell.accessoryView = switchView
                cell.setting.text = "Clear tokens on logout"
            }
            else if indexPath.row == 2 {
                let switchView = UISwitch(frame: .zero)
                switchView.setOn(false, animated: true)
                switchView.addTarget(self, action: #selector(self.autoReload), for: .valueChanged)
                cell.accessoryView = switchView
                cell.setting.text = "Auto reload repositories"
            }
            else if indexPath.row == 3 {
                cell.accessoryType = .disclosureIndicator
                //cell.selectionStyle = .default
                cell.setting.text = "Logout of GitHub"
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if(indexPath.row == 3) {
            
            Authorization.sharedInstance.grant.forgetTokens()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alert")
            
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            
            do {
                try Store.viewContext.execute(batchDeleteRequest)
                print("Successfully deleted data")
                
            } catch {
                print("Could not clear data")
            }
            
            let urlString = "https://github.com/logout"
            
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
            
        }
        
    }
    
    @objc
    func clearInfo() {
        if(UserDefaults.standard.string(forKey: "clear_info")=="off") {
            UserDefaults.standard.set("on", forKey: "clear_info")
        }
        else if(UserDefaults.standard.string(forKey: "clear_info")=="on") {
            UserDefaults.standard.set("off", forKey: "clear_info")
        }
    }
    
    @objc
    func autoReload() {
        if(UserDefaults.standard.string(forKey: "repo_reload")=="off") {
            UserDefaults.standard.set("on", forKey: "repo_reload")
        }
        else if(UserDefaults.standard.string(forKey: "repo_reload")=="on") {
            UserDefaults.standard.set("off", forKey: "repo_reload")
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        self.present(login, animated: true, completion: nil)
        Authorization.sharedInstance.grant.abortAuthorization()
    }
    
}
