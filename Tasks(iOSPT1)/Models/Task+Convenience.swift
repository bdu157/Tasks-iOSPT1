//
//  Task+Convenience.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/9/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData

//CaseIterable can also be used remove static var and add allCases. switch can also be used if we dont use static var or CaseIterable

enum TaskPriority: String {
    case low
    case normal
    case high
    case critical
    
    static var allPriorities: [TaskPriority] {
        return [.low, .normal, .high, .critical]
    }
}
//so this will help us create model
extension Task {
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .normal, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
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
