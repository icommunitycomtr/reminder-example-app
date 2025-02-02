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
    func fetchReminders()
    func updateFocusedDate(to date: Date)
    func isFocusedItemChanged(for indexPath: IndexPath) -> Bool
}

final class HomeViewModel {

    // MARK: Properties

    private var allReminders: [Reminder]
    private(set) var reminders: [Reminder] = []
    private var currentDate: Date = Date()
    var dates: [Date] = []
    var focusedItemIndexPath = IndexPath()
    var todayIndexPath = IndexPath()

    weak var inputDelegate: HomeViewModelInputProtocol?
    weak var outputDelegate: HomeViewModelOutputProtocol?

    // MARK: Init

    init(initialReminders: [Reminder], daysBefore: Int = 30, daysAfter: Int = 30) {
        allReminders = initialReminders
        dates = DateManager().generateDates(daysBefore: daysBefore, daysAfter: daysAfter)
        setTodaysIndex()
        inputDelegate = self
    }
}

// MARK: - Private Methods

extension HomeViewModel {
    /// Sorts the `reminders` array in-place:
    /// - Incomplete tasks first
    /// - Then completed tasks
    /// - Within each group, sort by date ascending
    func sortReminders() {
        reminders = reminders.sorted {
            if $0.isCompleted != $1.isCompleted {
                return $0.isCompleted == false
            }
            return $0.date < $1.date
        }.reversed()
    }

    /// Check if two reminders happen on the same day
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    /// Save the updated `allReminders` array to UserDefaults
    func persistAllReminders() {
        StorageManager.shared.saveReminders(allReminders)
    }

    func updateFocusedDate(to date: Date) {
        currentDate = date
        filterReminders(for: date)
    }

    func setTodaysIndex() {
        if let todayIndex = dates.firstIndex(where: { DateManager().isSameDay($0, Date()) }) {
            todayIndexPath = IndexPath(item: todayIndex, section: 0)
            focusedItemIndexPath = todayIndexPath
        } else {
            todayIndexPath = IndexPath(item: dates.count / 2, section: 0)
            focusedItemIndexPath = todayIndexPath
        }
    }
}

// MARK: - HomeViewModelInputProtocol

extension HomeViewModel: HomeViewModelInputProtocol {
    func fetchReminders() {
        allReminders = StorageManager.shared.fetchReminders()
    }

    func addReminder(_ reminder: Reminder) {
        allReminders.append(reminder)
        persistAllReminders()

        if isSameDay(reminder.date, currentDate) {
            reminders.append(reminder)
            sortReminders()
            outputDelegate?.reloadData()
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
        reminders = allReminders.filter { reminder in
            let sameDay = isSameDay(reminder.date, date)
            return sameDay
        }
        sortReminders()
        outputDelegate?.reloadData()
    }

    func isFocusedItemChanged(for indexPath: IndexPath) -> Bool {
        if focusedItemIndexPath != indexPath {
            focusedItemIndexPath = indexPath
            return true
        }
        return false
    }

    func isIndexPathFocused(_ indexPath: IndexPath) -> Bool {
        focusedItemIndexPath == indexPath ? true : false
    }
}
