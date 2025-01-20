//
//  ReminderCell.swift
//  Reminder
//
//  Created by Mert Ozseven on 19.01.2025.
//

import UIKit

class ReminderCell: UITableViewCell {

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
        view.layer.borderColor = UIColor.label.cgColor
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 8)

        return view
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
        label.text = "\(completedText)"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .secondaryLabel

        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circlebadge")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

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
        titleLabel.text = reminder.title
        completedLabel.isHidden = reminder.isCompleted ? false : true
        checkmarkImageView.image = reminder.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circlebadge")
    }
}

// MARK: - Private Methods

private extension ReminderCell {

    func configureView() {
        addViews()
        configureLayout()
    }

    func addViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(completedLabel)
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
        titleLabel.setupAnchors(
            top: containerView.layoutMarginsGuide.topAnchor,
            leading: containerView.layoutMarginsGuide.leadingAnchor,
            trailing: checkmarkImageView.leadingAnchor, paddingTrailing: 8,
            minHeight: 1
        )
        completedLabel.setupAnchors(
            top: titleLabel.bottomAnchor, paddingTop: 8,
            bottom: containerView.layoutMarginsGuide.bottomAnchor,
            leading: containerView.layoutMarginsGuide.leadingAnchor,
            trailing: checkmarkImageView.leadingAnchor, paddingTrailing: 8
        )
    }

}

// MARK: - Objective Methods

private extension ReminderCell {
    @objc func checkmarkTapped() {
        checkmarkImageView.image = checkmarkImageView.image == UIImage(systemName: "circlebadge") ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circlebadge")
        if reminder?.isCompleted == true {
            checkmarkImageView.image = UIImage(systemName: "circlebadge")
        } else {
            checkmarkImageView.image = UIImage(systemName: "circlebadge")
        }
    }
}

#Preview {
    let reminder = Reminder(title: "Title", date: Date(), completedDate: Date(), isCompleted: true)
    let cell = ReminderCell()
    cell.configure(with: reminder)
    return cell
}
