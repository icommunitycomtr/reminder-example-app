//
//  StorageManager.swift
//  Reminder
//
//  Created by Mert Ozseven on 23.01.2025.
//

import Foundation

final class StorageManager {

    // MARK: - Properties

    private let defaults = UserDefaults.standard
    private let remindersKey = "com.mertozseven.Reminder"

    // MARK: - Singleton

    static let shared = StorageManager()
    private init() {}
}

// MARK: - Public Methods

extension StorageManager {
    /// Saves an array of Reminder objects to UserDefaults.
    /// - Parameter reminders: The array of Reminder objects to save.
    func saveReminders(_ reminders: [Reminder]) {
        do {
            let data = try JSONEncoder().encode(reminders)
            defaults.set(data, forKey: remindersKey)
        } catch {
            print("Failed to encode reminders: \(error.localizedDescription)")
        }
    }

    /// Fetches an array of Reminder objects from UserDefaults.
    /// - Returns: The array of Reminder objects or an empty array if none found.
    func fetchReminders() -> [Reminder] {
        guard let data = defaults.data(forKey: remindersKey) else {
            return []
        }
        do {
            let reminders = try JSONDecoder().decode([Reminder].self, from: data)
            return reminders
        } catch {
            print("Failed to decode reminders: \(error.localizedDescription)")
            return []
        }
    }

    /// Clears all saved reminders from UserDefaults.
    func clearReminders() {
        defaults.removeObject(forKey: remindersKey)
    }

    /// Deletes a specific `Reminder` from UserDefaults.
    /// - Parameter reminder: The `Reminder` to be removed.
    func deleteReminder(_ reminder: Reminder) {
        var reminders = fetchReminders()
        reminders.removeAll { $0.id == reminder.id }
        saveReminders(reminders)
    }
}
