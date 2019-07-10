//
//  CoreDataStack.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/9/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack() //singleton so we can use this throughout the app

    //store property, computed property
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()   //to initialize this container property   so it gets called and recognized when it is called/ without this it requires init if you use let container
    
    //this is computed property
    var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
}
