//
//  Collection.swift
//  Reminder
//
//  Created by Mert Ozseven on 23.01.2025.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
