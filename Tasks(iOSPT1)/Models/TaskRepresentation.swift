//
//  TaskRepresentation.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/15/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation


//this is pretty much in between 
struct TaskRepresentation: Codable {
    var name: String
    var notes: String?
    var priority: String
    var identifier: String  //this is an optional String and type is UUID
}
