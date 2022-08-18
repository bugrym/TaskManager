//
//  Task.swift
//  TaskManager
//
//  Created by vbugrym on 03.07.2022.
//

import Foundation

class Task: Codable {
    let id: String
    let creationalDate: Date
    let description: String
    
    init(_ id: String, _ creationalDate: Date, _ description: String) {
        self.id = id
        self.creationalDate = creationalDate
        self.description = description
    }
}
