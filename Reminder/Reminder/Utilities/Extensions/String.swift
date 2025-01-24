//
//  String.swift
//  Reminder
//
//  Created by Mert Ozseven on 24.01.2025.
//

import Foundation

extension String {
    /// String extension to format date
    /// - Parameters:
    /// - date: Date
    /// - format: String
    /// - Returns: String
    /// - Example: let date = .formattedDate(from: Date(), format: "dd MMMM yyyy")
    static func formattedDate(from date: Date, format: String = "EEE, dd MMMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }

    static func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}
