//
//  HomeViewModel.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import Foundation

final class HomeViewModel {

    // MARK: Properties
//    private let reminderService: ReminderService
    var reminders: [Reminder] = []
    private var filteredReminders: [Reminder] = []
    private var isFiltering: Bool = false
}
