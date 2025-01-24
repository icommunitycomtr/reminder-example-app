//
//  HomeViewModel.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import Foundation

protocol HomeViewModelInputProtocol: AnyObject {
    func toggleReminder(at index: Int)
    func filterReminders(for date: Date)
}

final class HomeViewModel {

    // MARK: Properties

    private var allReminders: [Reminder] = {
        let calendar = Calendar.current
        let now = Date()

        return [
            Reminder(title: "Test Reminder 1",  date: calendar.date(byAdding: .day, value: -10, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 2\nWith multiple lines\nof text", date: calendar.date(byAdding: .day, value: -9, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 3",  date: calendar.date(byAdding: .day, value: -8, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 4",  date: calendar.date(byAdding: .day, value: -7, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 5",  date: calendar.date(byAdding: .day, value: -6, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 6",  date: calendar.date(byAdding: .day, value: -5, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 7",  date: calendar.date(byAdding: .day, value: -4, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 8",  date: calendar.date(byAdding: .day, value: -3, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 9",  date: calendar.date(byAdding: .day, value: -2, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 10", date: calendar.date(byAdding: .day, value: -1, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 11", date: now, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 12", date: calendar.date(byAdding: .day, value: 1, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 13", date: calendar.date(byAdding: .day, value: 2, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 14", date: calendar.date(byAdding: .day, value: 3, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 15", date: calendar.date(byAdding: .day, value: 4, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 16", date: calendar.date(byAdding: .day, value: 5, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 17", date: calendar.date(byAdding: .day, value: 6, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 18", date: calendar.date(byAdding: .day, value: 7, to: now)!, completedDate: nil, isCompleted: false),
            Reminder(title: "Test Reminder 19", date: calendar.date(byAdding: .day, value: 8, to: now)!, completedDate: nil, isCompleted: false)
        ]
    }()

    private(set) var reminders: [Reminder] = []

    weak var inputDelegate: HomeViewModelInputProtocol?
    weak var outputDelegate: HomeViewModelOutputProtocol?

    // MARK: Init
    init() {
        self.inputDelegate = self
    }
}

// MARK: - Private Methods

extension HomeViewModel {
    /// Sorts the `reminders` array in-place:
    /// - Incomplete tasks first
    /// - Then completed tasks
    /// - Within each group, sort by date ascending
    private func sortReminders() {
        reminders = reminders.sorted {
            if $0.isCompleted != $1.isCompleted {
                return $0.isCompleted == false  // incomplete first
            }
            return $0.date < $1.date
        }
    }

    /// Check if two reminders happen on the same day
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}


// MARK: - HomeViewModelInputProtocol

extension HomeViewModel: HomeViewModelInputProtocol {
    /// Toggle a single reminder's `isCompleted` property
    func toggleReminder(at index: Int) {
        let oldIndex = index
        let reminderToToggle = reminders[index]

        if let idxInAll = allReminders.firstIndex(where: { $0.id == reminderToToggle.id }) {
            var updated = allReminders[idxInAll]
            updated.isCompleted.toggle()
            allReminders[idxInAll] = updated
        }

        if let selectedReminder = reminders[safe: oldIndex] {
            // Because we want to get the date from the old item in case you store it
            // but realistically you'd be storing the date you last filtered on:
            filterReminders(for: reminderToToggle.date)
        } else {
            // If the old index doesn't exist for some reason, just reload
            outputDelegate?.reloadData()
        }

        // Calculate the new index within `reminders` after the sort
        let newIndex = reminders.firstIndex { $0.id == reminderToToggle.id } ?? oldIndex

        // Move the row with an animation (if you want the fancy effect).
        // The table reload also happens inside `updateRow` in the completion closure.
        outputDelegate?.updateRow(from: oldIndex, to: newIndex)
    }

    /// Filter the reminders array for the given date
    func filterReminders(for date: Date) {
        reminders = allReminders.filter {
            isSameDay($0.date, date)
        }
        sortReminders()
        outputDelegate?.reloadData()
    }
}
