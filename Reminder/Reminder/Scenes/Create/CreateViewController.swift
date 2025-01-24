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

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()

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

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dateStackViewTapped)))
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

    private lazy var hourStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeStackViewTapped)))
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

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(saveAndDismiss), for: .touchUpInside)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
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
        view.backgroundColor = .clear
        reminderTextView.delegate = self
        addViews()
        configureLayout()
        handleTraitChanges()
        view.addDismissKeyboardGesture()
    }

    func addViews() {
        view.addSubview(blurEffectView)
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
        containerView.addSubview(closeButton)
    }

    func configureLayout() {
        blurEffectView.setupAnchors(
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
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
        closeButton.setupAnchors(
            top: containerView.layoutMarginsGuide.topAnchor,
            trailing: containerView.layoutMarginsGuide.trailingAnchor,
            width: 32,
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
        DatePickerManager.shared.presentDatePicker(
            from: self,
            sourceView: dateStackView,
            initialDate: selectedDate,
            pickerMode: .date,
            pickerStyle: .inline,
            onDateSelected: { [weak self] newDate in
                self?.viewModel.inputDelegate?.updateDate(newDate)
            }
        )
    }

    @objc func timeStackViewTapped() {
        DatePickerManager.shared.presentDatePicker(
            from: self,
            sourceView: hourStackView,
            initialDate: selectedDate,
            pickerMode: .time,
            pickerStyle: .wheels,
            popoverSize: CGSize(width: 160, height: 160),
            onDateSelected: { [weak self] newTime in
                self?.viewModel.inputDelegate?.updateTime(newTime)
            }
        )
    }

    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func saveAndDismiss() {
        guard let title = reminderTextView.text,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Show an alert if the title is empty
            let alert = UIAlertController(
                title: "Error",
                message: "Please enter a valid title for the reminder.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        viewModel.inputDelegate?.saveReminder(title: title) { [weak self] newReminder in
            guard let self = self, let reminder = newReminder else {
                return
            }
            NotificationCenter.default.post(name: .didCreateNewReminder, object: reminder)
            self.dismiss(animated: true)
        }
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

#Preview {
    CreateViewController(initialDate: Date())
}
