//
//  ToDoItem.swift
//  Daily-V3
//
//  Created by Carol Yu on 5/1/22.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var course: String
    var dueDate: Date
    var notes: String
    var dueDateSet: Bool
    var reminderSet: Bool
    var reminderDate: Date
    var notificationID: String?
    var completed: Bool
}
