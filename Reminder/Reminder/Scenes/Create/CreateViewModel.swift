//
//  CreateViewModel.swift
//  Reminder
//
//  Created by Mert Ozseven on 23.01.2025.
//

import Foundation

protocol CreateViewModelInputProtocol: AnyObject {
    func updateDate(_ date: Date)
    func updateTime(_ time: Date)
    func saveReminder(title: String, completion: (Reminder?) -> Void)
}

final class CreateViewModel {
    // MARK: Properties
    weak var inputDelegate: CreateViewModelInputProtocol?
    weak var outputDelegate: CreateViewModelOutputProtocol?

    private var selectedDate: Date

    // MARK: Init
    init(initialDate: Date) {
        self.selectedDate = initialDate
        self.inputDelegate = self
    }
}

// MARK: - Input Protocol Implementation

extension CreateViewModel: CreateViewModelInputProtocol {
    func updateDate(_ date: Date) {
        selectedDate = date
        outputDelegate?.didUpdateDate(date)
    }

    func updateTime(_ time: Date) {
        selectedDate = time
        outputDelegate?.didUpdateTime(time)
    }

    func saveReminder(title: String, completion: (Reminder?) -> Void) {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completion(nil)
            return
        }

        let newReminder = Reminder(
            title: title,
            date: selectedDate,
            completedDate: nil,
            isCompleted: false
        )
        completion(newReminder)
    }
}
