//
//  ReminderCell.swift
//  Reminder
//
//  Created by Mert Ozseven on 19.01.2025.
//

import UIKit

final class ReminderCell: UITableViewCell {

    // MARK: Properties

    static let identifier = "TaskCell"
    private var reminder: Reminder?
    private var completedText: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date).description.count == 1 ? "0\(calendar.component(.minute, from: date))" : calendar.component(.minute, from: date).description

        return "completed in \(hour):\(minute)"
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.dynamicColor(
            light: .label,
            dark: .label
        ).cgColor
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .label

        return label
    }()

    private lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .secondaryLabel
        label.isHidden = true
        label.alpha = 0
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circlebadge")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    // MARK: Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public Methods

extension ReminderCell {
    func configure(with reminder: Reminder) {
        self.reminder = reminder
        titleLabel.text = reminder.title
        completedLabel.isHidden = !reminder.isCompleted
        checkmarkImageView.image = reminder.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circlebadge")
        checkIsCompleted()
    }
}

// MARK: - Private Methods

private extension ReminderCell {
    func configureView() {
        selectionStyle = .none
        checkIsCompleted()
        addViews()
        configureLayout()
        handleTraitChanges()
    }

    func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(completedLabel)
        containerView.addSubview(checkmarkImageView)
    }

    func configureLayout() {
        containerView.setupAnchors(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor, paddingBottom: 8,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor
        )
        checkmarkImageView.setupAnchors(
            trailing: containerView.layoutMarginsGuide.trailingAnchor,
            centerY: containerView.centerYAnchor,
            width: 32,
            height: 32
        )
        stackView.setupAnchors(
            top: containerView.layoutMarginsGuide.topAnchor,
            bottom: containerView.layoutMarginsGuide.bottomAnchor,
            leading: containerView.layoutMarginsGuide.leadingAnchor,
            trailing: checkmarkImageView.leadingAnchor, paddingTrailing: 8
        )
    }

    func checkIsCompleted() {
        guard let reminder = reminder else { return }

        if reminder.isCompleted {
            UIView.animate(withDuration: 0.001, animations: {
                self.completedLabel.isHidden = false
                self.completedLabel.text = self.completedText

                self.completedLabel.alpha = 1
                self.checkmarkImageView.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
                self.titleLabel.textColor = .secondaryLabel
                self.handleTraitChanges()
            }) { _ in
                self.updateLayout()
            }

        } else {
            UIView.animate(withDuration: 0.001, animations: {
                self.completedLabel.isHidden = true
                self.completedLabel.alpha = 0
                self.checkmarkImageView.image = UIImage(systemName: "circlebadge")
                self.titleLabel.textColor = .label
                self.handleTraitChanges()
            }) { _ in
                self.updateLayout()
            }
        }
    }

    func updateLayout() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    func updateBorderColor() {
        containerView.layer.borderColor = UIColor.dynamicColor(
            light: .label,
            dark: .label
        ).cgColor
    }

    func handleTraitChanges() {
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.updateBorderColor()
        }
    }
}
