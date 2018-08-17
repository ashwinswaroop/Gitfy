//
//  AlertDataSource.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/6/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import CoreData

class AlertDataSource {
    
    let controller: NSFetchedResultsController<NSFetchRequestResult>
    let request: NSFetchRequest<NSFetchRequestResult> = Alert.fetchRequest()
    
    let defaultSort: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Alert.alertDate), ascending: false)
    
    init(context: NSManagedObjectContext, sortDescriptors: [NSSortDescriptor] = []) {
        var sort: [NSSortDescriptor] = sortDescriptors
        if sort.isEmpty { sort = [defaultSort] }
        
        request.sortDescriptors = sort
        
        controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: DataSource APIs
    
    func fetch(completion: ((Result) -> ())?) {
        do {
            try controller.performFetch()
            completion?(.success)
        } catch let error {
            completion?(.fail(error))
        }
    }
    
    var count: Int { return controller.fetchedObjects?.count ?? 0 }
    
    func anyAlerts(at indexPath: IndexPath) -> AlertReference {
        let c: Alert = controller.object(at: indexPath) as! Alert
        return AlertReference(reference: c.objectID, repoName: c.repoName, alertDescription: c.alertDescription, authorName: c.authorName, alertTitle: c.alertTitle, alertAction: c.alertAction, alertDate: c.alertDate, authorIcon: c.authorIcon, alertEvent: c.alertEvent)
    }
    
}

enum Result {
    case success, fail(Error)
} 

extension NSManagedObjectContext {
    
    // MARK: Load data
    
    var dataSource: AlertDataSource { return AlertDataSource(context: self) }
    
    // MARK: Data manupulation
    
    func add(alerts: AlertReference, completion: ((Result) -> ())?) {
        perform {
            let entity: Alert = Alert(context: self)
            entity.alertAction = alerts.alertAction
            entity.alertDate = alerts.alertDate
            entity.alertDescription = alerts.alertDescription
            entity.alertEvent = alerts.alertEvent
            entity.alertTitle = alerts.alertTitle
            entity.authorIcon = alerts.authorIcon
            entity.authorName = alerts.authorName
            entity.repoName = alerts.repoName
            self.save(completion: completion)
        }
    }
    
    func delete(alerts: AlertReference, completion: ((Result) -> ())?) {
        guard alerts.reference != nil else {
            print("No reference")
            return
        }
        perform {
            let entity: Alert? = self.object(with: alerts.reference) as? Alert
            self.delete(entity!)
            self.save(completion: completion)
        }
    }
    
    func save(completion: ((Result) -> ())?) {
        do {
            try self.save()
            completion?(.success)
        } catch let error {
            self.rollback()
            completion?(.fail(error))
        }
    }
}

