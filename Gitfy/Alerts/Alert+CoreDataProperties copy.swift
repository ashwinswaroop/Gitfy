//
//  Alert+CoreDataProperties.swift
//  
//
//  Created by Ashwin Swaroop on 8/6/18.
//
//

import Foundation
import CoreData


extension Alert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alert> {
        return NSFetchRequest<Alert>(entityName: "Alert")
    }

    @NSManaged public var repoName: String?
    @NSManaged public var alertDescription: String?
    @NSManaged public var authorName: String?
    @NSManaged public var alertTitle: String?
    @NSManaged public var alertAction: String?
    @NSManaged public var alertDate: String?
    @NSManaged public var authorIcon: String?
    @NSManaged public var alertEvent: String?

}
