//
//  HomeTopView.swift
//  Reminder
//
//  Created by Mert Ozseven on 17.01.2025.
//

import UIKit

protocol HomeTopViewDelegate: AnyObject {
    func didTapCalendar()
}

final class HomeTopView: UIView {

    // MARK: Properties

    weak var delegate: HomeTopViewDelegate?

    private var partOfDay: String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 6..<12:
            return "Good Morning"
        case 12..<18:
            return "Good Afternoon"
        case 18..<24:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    private var name = "Mert"

    private lazy var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "\(partOfDay)\n\(name)"
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.numberOfLines = 0

        return label
    }()

    let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    // MARK: Inits

    init(name: String) {
        super.init(frame: .zero)
        self.name = name
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension HomeTopView {
    private func configureView() {
        backgroundColor = .systemBackground
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        addViews()
        configureLayout()
        setupActions()
    }

    private func addViews() {
        addSubview(greetingLabel)
        addSubview(calendarImageView)
    }

    private func configureLayout() {
        greetingLabel.setupAnchors(
            top: layoutMarginsGuide.topAnchor,
            bottom: layoutMarginsGuide.bottomAnchor,
            leading: layoutMarginsGuide.leadingAnchor,
            trailing: calendarImageView.leadingAnchor,
            paddingTrailing: 24
        )
        calendarImageView.setupAnchors(
            trailing: layoutMarginsGuide.trailingAnchor,
            centerY: centerYAnchor,
            width: 54,
            height: 54
        )
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCalendar))
        calendarImageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Objective Methods

private extension HomeTopView {
    @objc func didTapCalendar() {
        delegate?.didTapCalendar()
    }
}
