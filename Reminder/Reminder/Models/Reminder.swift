//
//  Reminder.swift
//  Reminder
//
//  Created by Mert Ozseven on 19.01.2025.
//w

import Foundation

struct Reminder: Codable {
    var id = UUID().uuidString
    var title: String
    var date: Date
    var completedDate: Date?
    var isCompleted: Bool
}
