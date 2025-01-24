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
    func addReminder(_ reminder: Reminder)
}

final class HomeViewModel {

    // MARK: Properties

    private var allReminders: [Reminder]
    private(set) var reminders: [Reminder] = []

    weak var inputDelegate: HomeViewModelInputProtocol?
    weak var outputDelegate: HomeViewModelOutputProtocol?

    // MARK: Init

    init(initialReminders: [Reminder]) {
        self.allReminders = initialReminders
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
                return $0.isCompleted == false
            }
            return $0.date < $1.date
        }.reversed()
    }

    /// Check if two reminders happen on the same day
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    /// Save the updated `allReminders` array to UserDefaults
    private func persistAllReminders() {
        StorageManager.shared.saveReminders(allReminders)
    }
}

// MARK: - HomeViewModelInputProtocol

extension HomeViewModel: HomeViewModelInputProtocol {

    func addReminder(_ reminder: Reminder) {
        allReminders.append(reminder)
        persistAllReminders()

        if !reminders.isEmpty, let anyReminderDate = reminders.first?.date {
            if isSameDay(reminder.date, anyReminderDate) {
                reminders.append(reminder)
                sortReminders()
                outputDelegate?.reloadData()
            }
        } else {

        }
    }

    func toggleReminder(at index: Int) {
        let oldIndex = index
        let reminderToToggle = reminders[index]

        if let idxInAll = allReminders.firstIndex(where: { $0.id == reminderToToggle.id }) {
            var updated = allReminders[idxInAll]

            updated.isCompleted.toggle()

            if updated.isCompleted {
                updated.completedDate = Date()
            } else {
                updated.completedDate = nil
            }

            allReminders[idxInAll] = updated
            persistAllReminders()
        }

        if let _ = reminders[safe: oldIndex] {
            filterReminders(for: reminderToToggle.date)
        } else {
            outputDelegate?.reloadData()
        }

        let newIndex = reminders.firstIndex { $0.id == reminderToToggle.id } ?? oldIndex
        outputDelegate?.updateRow(from: oldIndex, to: newIndex)
    }

    func filterReminders(for date: Date) {
        reminders = allReminders.filter {
            isSameDay($0.date, date)
        }
        sortReminders()
        outputDelegate?.reloadData()
    }
}
