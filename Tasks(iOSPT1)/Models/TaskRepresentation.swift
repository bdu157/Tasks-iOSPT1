//
//  TaskRepresentation.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/15/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct TaskRepresentation: Codable {
    var name: String
    var notes: String?
    var priority: String
    var identifier: String
}
