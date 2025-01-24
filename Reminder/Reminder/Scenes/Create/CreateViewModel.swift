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
}

protocol CreateViewModelOutputProtocol: AnyObject {
    func didUpdateDate(_ date: Date)
    func didUpdateTime(_ time: Date)
}

final class CreateViewModel {
    weak var inputDelegate: CreateViewModelInputProtocol?
    weak var outputDelegate: CreateViewModelOutputProtocol?

    private var selectedDate: Date

    init(initialDate: Date) {
        self.selectedDate = initialDate
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
}
