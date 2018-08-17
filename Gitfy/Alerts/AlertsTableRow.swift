//
//  AlertsTableRow.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/5/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import UIKit

class AlertsTableRow: UITableViewCell {
    //Uses attributes of the Alert class to populate these fields
    @IBOutlet weak var alertDescription: UILabel! //repoName: alertDescription
    @IBOutlet weak var authorIcon: UIImageView! //authorIcon    
}
