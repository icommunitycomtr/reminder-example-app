//
//  DatePickerViewController.swift
//  Reminder
//
//  Created by Mert Ozseven on 20.01.2025.
//

import UIKit

final class DatePickerViewController: UIViewController {

    // MARK: Properties

    private let initialDate: Date
    private var pickerMode: UIDatePicker.Mode = .date
    private var pickerStyle: UIDatePickerStyle = .inline
    var onDateSelected: ((Date) -> Void)?

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = pickerMode
        picker.preferredDatePickerStyle = pickerStyle
        picker.tintColor = .label
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()

    // MARK: Inits

    init(pickerMode: UIDatePicker.Mode,
             pickerStyle: UIDatePickerStyle,
             defaultDate: Date
        ) {
            self.pickerMode = pickerMode
            self.pickerStyle = pickerStyle
            self.initialDate = defaultDate
            super.init(nibName: nil, bundle: nil)
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
    func configureView() {
        view.backgroundColor = .systemBackground
        datePicker.date = initialDate
        addViews()
        configureLayout()
    }

    func addViews() {
        view.addSubview(datePicker)
    }

    func configureLayout() {
        datePicker.setupAnchors(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
}

// MARK: - Objective Methods

private extension DatePickerViewController {
    @objc func dateChanged(_ sender: UIDatePicker) {
        onDateSelected?(sender.date)
    }
}
