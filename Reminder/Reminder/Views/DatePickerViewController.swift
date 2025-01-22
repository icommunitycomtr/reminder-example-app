//
//  DatePickerViewController.swift
//  Reminder
//
//  Created by Mert Ozseven on 20.01.2025.
//

import UIKit

class DatePickerViewController: UIViewController {

    // MARK: Properties

    private var pickerMode: UIDatePicker.Mode = .date
    private var pickerStyle: UIDatePickerStyle = .inline

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = pickerMode
        picker.preferredDatePickerStyle = pickerStyle
        picker.tintColor = .label
        return picker
    }()

    // MARK: Inits

    init(pickerMode: UIDatePicker.Mode, pickerStyle: UIDatePickerStyle) {
        super.init(nibName: nil, bundle: nil)
        self.pickerMode = pickerMode
        self.pickerStyle = pickerStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}

// MARK: - Private Methods

private extension DatePickerViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
        addViews()
        configureLayout()
    }

    private func addViews() {
        view.addSubview(datePicker)
    }

    private func configureLayout() {
        datePicker.setupAnchors(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
}
