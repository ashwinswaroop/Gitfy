//
//  AlertReference.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/5/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import CoreData

struct AlertReference {
    
    var reference: NSManagedObjectID!
    var repoName: String?
    var alertDescription: String?
    var authorName: String?
    var alertTitle: String?
    var alertAction: String?
    var alertDate: String?
    var authorIcon: String?
    var alertEvent: String?
}
