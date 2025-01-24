//
//  HomeTopFooterView.swift
//  Reminder
//
//  Created by Mert Ozseven on 23.01.2025.
//

import UIKit

final class HomeTopFooterView: UITableViewHeaderFooterView {

    // MARK: Properties

    static let identifier = "ReminderSectionHeader"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Reminders"
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()

    // MARK: Inits
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private Methods
private extension HomeTopFooterView {
    func configureView() {
        contentView.backgroundColor = .systemBackground
        addViews()
        configureLayout()
    }

    func addViews() {
        contentView.addSubview(titleLabel)
    }

    func configureLayout() {
        titleLabel.setupAnchors(
            top: contentView.topAnchor,
            bottom: contentView.bottomAnchor, paddingBottom: 8,
            leading: contentView.leadingAnchor, paddingLeading: 8,
            trailing: contentView.trailingAnchor
        )
    }
}
