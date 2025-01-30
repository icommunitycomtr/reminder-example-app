//
//  DateCell.swift
//  Reminder
//
//  Created by Mert Ozseven on 27.01.2025.
//

import UIKit

final class DateCell: UICollectionViewCell {

    // MARK: Properties

    static let identifier = "DateCell"

    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    // MARK: inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods

extension DateCell {
    func configure(with date: String) {
        self.dateLabel.text = date
    }
}

// MARK: - Private Methods

private extension DateCell {
    func configureView () {
        addViews()
        configureLayout()
    }

    func addViews() {
        contentView.addSubview(dateLabel)
    }

    func configureLayout() {
        dateLabel.setupAnchors(
            centerX: contentView.centerXAnchor,
            centerY: contentView.centerYAnchor
        )
    }
}
