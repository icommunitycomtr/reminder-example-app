//
//  DateManager.swift
//  Reminder
//
//  Created by Mert Ozseven on 27.01.2025.
//


import Foundation

final class DateManager {

    private let calendar = Calendar.current

    func generateDates(
        daysBefore: Int = 30,
        daysAfter: Int = 30
    ) -> [Date] {
        let now = Date()
        var dates: [Date] = []

        let startDate = calendar.date(byAdding: .day, value: -daysBefore, to: now)!
        let endDate   = calendar.date(byAdding: .day, value: daysAfter, to: now)!

        var currentDate = startDate
        while currentDate <= endDate {
            dates.append(currentDate)
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        return dates
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }

    func isSameDay(_ firstDay: Date, _ secondDay: Date) -> Bool {
        calendar.isDate(firstDay, inSameDayAs: secondDay)
    }
}
