//
//  HomeViewModel.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import Foundation

protocol HomeViewModelInputProtocol: AnyObject {
    func toggleReminder(at index: Int)
}

final class HomeViewModel {

    // MARK: - Properties

    weak var inputDelegate: HomeViewModelInputProtocol?
    weak var outputDelegate: HomeViewModelOutputProtocol?

    private(set) var reminders: [Reminder] = [
        Reminder(title: "Test Reminder 1", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 2\nWith multiple lines\nof text", date: Date(), completedDate: Date(), isCompleted: false),
        Reminder(title: "Test Reminder 3", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 4", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 5", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 6", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 7", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 8", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 9", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 10", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 11", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 12", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 13", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 14", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 15", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 16", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 17", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 18", date: Date(), completedDate: nil, isCompleted: false),
        Reminder(title: "Test Reminder 19", date: Date(), completedDate: nil, isCompleted: false),
    ]

    init() {
        inputDelegate = self
    }

    // MARK: - Private Methods

    private func sortReminders() {
        reminders = reminders.sorted {
            if $0.isCompleted != $1.isCompleted {
                return $0.isCompleted
            }
            return $0.date < $1.date
        }
    }
}

// MARK: - HomeViewModelInputProtocol

extension HomeViewModel: HomeViewModelInputProtocol {
    func toggleReminder(at index: Int) {
        var reminder = reminders[index]
        reminder.isCompleted.toggle()
        let originalIndex = index
        reminders[index] = reminder
        sortReminders()
        let newIndex = reminders.firstIndex { $0.id == reminder.id } ?? originalIndex
        outputDelegate?.updateRow(from: originalIndex, to: newIndex)
    }
}
