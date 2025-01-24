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
}

// MARK: - Public Methods

extension DatePickerManager {
    /// Presents a date picker view controller.
    /// - Parameters:
    ///  - viewController: The view controller to present the date picker.
    ///  - sourceView: The view to anchor the popover.
    ///  - initialDate: The initial date to display in the picker.
    ///  - pickerMode: The mode of the date picker.
    ///  - pickerStyle: The style of the date picker.
    ///  - popoverSize: The size of the popover.
    ///  - onDateSelected: The closure to be called when a date is selected
    ///  - selectedDate: The selected date.
    ///  - Example:
    ///  ```
    ///  DatePickerManager.shared.presentDatePicker(
    ///     from: self,
    ///     sourceView: view,
    ///     initialDate: Date(),
    ///     pickerMode: .date,
    ///     pickerStyle: .inline,
    ///     onDateSelected: { date in
    ///     print(date)
    ///     }
    ///  )
    ///  ```
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
