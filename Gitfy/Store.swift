//
//  Store.swift
//  Gitfy
//
//  Created by Ashwin Swaroop on 8/6/18.
//  Copyright © 2018 Ashwin Swaroop. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Store {
    private init() {}
    private static let shared: Store = Store()
    
    lazy var container: NSPersistentContainer = {
        
        // The name of your .xcdatamodeld file.
        guard let url = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Create the .xcdatamodeld file with the correct name")
            // If you're setting up this container in a different bundle than the app,
            // Use Bundle(for: Store.self) assuming `CoreDataStore` is in that bundle.
        }
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, _ in }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // MARK: APIs
    
    /// For main queue use only, simple rule is don't access it from any queue other than main!!!
    static var viewContext: NSManagedObjectContext { return shared.container.viewContext }
    
    /// Context for use in background.
    static var newContext: NSManagedObjectContext { return shared.container.newBackgroundContext() }
}
