//
//  DatePickerManager.swift
//  Reminder
//
//  Created by Mert Ozseven on 24.01.2025.
//

import UIKit

final class DatePickerManager {

    // MARK: Singleton

    static let shared = DatePickerManager()

    private init() {}

    // MARK: Methods

    func presentDatePicker(
        from viewController: UIViewController,
        sourceView: UIView,
        initialDate: Date,
        pickerMode: UIDatePicker.Mode,
        pickerStyle: UIDatePickerStyle,
        popoverSize: CGSize = CGSize(width: 320, height: 320),
        onDateSelected: @escaping (Date) -> Void
    ) {
        let datePickerVC = DatePickerViewController(
            pickerMode: pickerMode,
            pickerStyle: pickerStyle,
            defaultDate: initialDate
        )
        datePickerVC.onDateSelected = { selectedDate in
            onDateSelected(selectedDate)
        }

        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.preferredContentSize = popoverSize

        if let popover = datePickerVC.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
            popover.delegate = viewController as? UIPopoverPresentationControllerDelegate
            popover.backgroundColor = .systemBackground
        }

        viewController.present(datePickerVC, animated: true, completion: nil)
    }
}
