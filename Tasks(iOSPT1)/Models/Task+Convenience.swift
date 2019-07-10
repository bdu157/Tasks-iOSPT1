//
//  Task+Convenience.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/9/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

//so this will help us create model
extension Task {
    convenience init(name: String, notes: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
    }
}


/*
//this is what we get using this conveinence init so we can have these initializer like struct Task2 below
let task = Task(name: <#T##String#>, notes: <#T##String?#>, context: <#T##NSManagedObjectContext#>)


struct Task2 {
    var name: String
    var note: String?
}

let task2 = Task2(name: <#T##String#>, note: <#T##String?#>)  //this comes with initializer
*/
