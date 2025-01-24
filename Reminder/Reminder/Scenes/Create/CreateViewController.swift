//
//  CreateViewController.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import UIKit

protocol CreateViewModelOutputProtocol: AnyObject {
    func didUpdateDate(_ date: Date)
    func didUpdateTime(_ time: Date)
}

final class CreateViewController: UIViewController {

    // MARK: Properties

    private let viewModel: CreateViewModel
    private var selectedDate: Date

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.tertiaryLabel.cgColor
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        return view
    }()

    private let mainVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()

    private let newTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "New Task"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        return label
    }()

    private let remindLabel: UILabel = {
        let label = UILabel()
        label.text = "Remind"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()

    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        return stackView
    }()

    private let calendarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .label
        return imageView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = .formattedDate(from: selectedDate)
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    private let hourStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        return stackView
    }()

    private let clockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .label
        return imageView
    }()

    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.text = .formattedTime(from: selectedDate)
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    private let reminderTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .secondaryLabel
        textView.font = .preferredFont(forTextStyle: .body)
        textView.text = "Enter your reminder"
        return textView
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: Init

    init(initialDate: Date) {
        self.selectedDate = initialDate
        self.viewModel = CreateViewModel(initialDate: initialDate)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViewModelBindings()
    }
}

// MARK: - Private Methods

private extension CreateViewController {
    func configureView() {
        view.backgroundColor = .secondarySystemBackground
        reminderTextView.delegate = self
        addViews()
        configureLayout()
        handleTraitChanges()
        view.addDismissKeyboardGesture()

        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateStackViewTapped))
        dateStackView.addGestureRecognizer(dateTapGesture)

        let timeTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeStackViewTapped))
        hourStackView.addGestureRecognizer(timeTapGesture)
    }

    func addViews() {
        view.addSubview(containerView)
        containerView.addSubview(mainVerticalStackView)
        mainVerticalStackView.addArrangedSubview(newTaskLabel)
        mainVerticalStackView.addArrangedSubview(remindLabel)
        mainVerticalStackView.addArrangedSubview(dateStackView)
        dateStackView.addArrangedSubview(calendarIcon)
        dateStackView.addArrangedSubview(dateLabel)
        mainVerticalStackView.addArrangedSubview(hourStackView)
        hourStackView.addArrangedSubview(clockIcon)
        hourStackView.addArrangedSubview(hourLabel)
        containerView.addSubview(reminderTextView)
        containerView.addSubview(saveButton)
    }

    func configureLayout() {
        containerView.setupAnchors(
            leading: view.layoutMarginsGuide.leadingAnchor,
            trailing: view.layoutMarginsGuide.trailingAnchor,
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            height: 348
        )
        mainVerticalStackView.setupAnchors(
            top: containerView.layoutMarginsGuide.topAnchor,
            bottom: reminderTextView.topAnchor, paddingBottom: 8,
            leading: containerView.layoutMarginsGuide.leadingAnchor,
            trailing: containerView.layoutMarginsGuide.trailingAnchor
        )
        reminderTextView.setupAnchors(
            bottom: saveButton.layoutMarginsGuide.topAnchor, paddingBottom: 16,
            leading: containerView.layoutMarginsGuide.leadingAnchor,
            trailing: containerView.layoutMarginsGuide.trailingAnchor,
            height: 140
        )
        saveButton.setupAnchors(
            bottom: containerView.layoutMarginsGuide.bottomAnchor,
            trailing: containerView.layoutMarginsGuide.trailingAnchor,
            width: 64,
            height: 32
        )
    }

    func setupViewModelBindings() {
        viewModel.outputDelegate = self
        viewModel.inputDelegate = viewModel
    }

    func updateBorderColor() {
        containerView.layer.borderColor = UIColor.dynamicColor(
            light: .tertiaryLabel,
            dark: .tertiaryLabel
        ).cgColor
    }

    func handleTraitChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateBorderColor()
        }
    }

    func presentPopover(_ viewController: UIViewController, sourceView: UIView, width: CGFloat = 320, height: CGFloat = 320) {
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: width, height: height)
        if let popover = viewController.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
            popover.permittedArrowDirections = .up
            popover.delegate = self
        }
        present(viewController, animated: true)
    }
}

// MARK: - Objective Methods

private extension CreateViewController {
    @objc func dateStackViewTapped() {
        let datePickerVC = DatePickerViewController(
            pickerMode: .date,
            pickerStyle: .inline,
            defaultDate: selectedDate
        )
        datePickerVC.onDateSelected = { [weak self] newDate in
            self?.viewModel.inputDelegate?.updateDate(newDate)
        }
        presentPopover(datePickerVC, sourceView: dateStackView, width: 320, height: 320)
    }

    @objc func timeStackViewTapped() {
        let timePickerVC = DatePickerViewController(
            pickerMode: .time,
            pickerStyle: .wheels,
            defaultDate: selectedDate
        )
        timePickerVC.onDateSelected = { [weak self] newTime in
            self?.viewModel.inputDelegate?.updateTime(newTime)
        }
        presentPopover(timePickerVC, sourceView: hourStackView, width: 160, height: 160)
    }
}

// MARK: - ViewModel Output Delegate

extension CreateViewController: CreateViewModelOutputProtocol {
    func didUpdateDate(_ date: Date) {
        self.selectedDate = date
        self.dateLabel.text = .formattedDate(from: date)
    }

    func didUpdateTime(_ time: Date) {
        self.selectedDate = time
        self.hourLabel.text = .formattedTime(from: time)
    }
}

// MARK: - UITextViewDelegate

extension CreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .secondaryLabel {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your reminder"
            textView.textColor = .secondaryLabel
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension CreateViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
