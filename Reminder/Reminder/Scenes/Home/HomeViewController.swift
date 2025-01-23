//
//  HomeViewController.swift
//  Reminder
//
//  Created by Mert Ozseven on 16.01.2025.
//

import UIKit

protocol HomeViewModelOutputProtocol: AnyObject {
    func updateRow(from oldIndex: Int, to newIndex: Int)
    func reloadData()
}

final class HomeViewController: UIViewController {

    // MARK: Properties

    private var viewModel: HomeViewModel {
        didSet {
            reminderTableView.reloadData()
        }
    }

    private var selectedDate = Date()
    private var name: String = "Mert"

    private lazy var topView = HomeTopView(name: name)

    private lazy var reminderTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
        tableView.register(HomeTopFooterView.self, forHeaderFooterViewReuseIdentifier: HomeTopFooterView.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    private let addButton: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 56, weight: .regular)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 28
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    // MARK: Inits

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        topView.delegate = self
        viewModel.outputDelegate = self
        viewModel.filterReminders(for: selectedDate)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reminderTableView.layoutTableHeaderView()
    }
}

// MARK: - Private Methods

private extension HomeViewController {
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        addViews()
        configureLayout()
        setupTableHeaderView()
    }

    func addViews() {
        view.addSubview(reminderTableView)
        view.addSubview(addButton)
    }

    func configureLayout() {
        reminderTableView.setupAnchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: view.bottomAnchor,
            leading: view.layoutMarginsGuide.leadingAnchor,
            trailing: view.layoutMarginsGuide.trailingAnchor
        )
        addButton.setupAnchors(
            bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16,
            trailing: view.layoutMarginsGuide.trailingAnchor, paddingTrailing: 16,
            width: 56,
            height: 56
        )
    }

    func setupTableHeaderView() {
        reminderTableView.tableHeaderView = topView
        reminderTableView.layoutTableHeaderView()
    }
}

// MARK: - HomeViewModelOutputProtocol

extension HomeViewController: HomeViewModelOutputProtocol {
    func updateRow(from oldIndex: Int, to newIndex: Int) {
        reminderTableView.performBatchUpdates({
            self.reminderTableView.moveRow(
                at: IndexPath(row: oldIndex, section: 0),
                to: IndexPath(row: newIndex, section: 0)
            )
        }, completion: { _ in
            self.reloadData()
        })
    }

    func reloadData() {
        reminderTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reminders.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ReminderCell.identifier,
            for: indexPath
        ) as? ReminderCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        let reminder = viewModel.reminders[indexPath.row]
        cell.configure(with: reminder)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.inputDelegate?.toggleReminder(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int
    ) -> UIView? {
        if section == 0 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HomeTopFooterView.identifier
            ) as? HomeTopFooterView else {
                return nil
            }
            return headerView
        }
        return nil
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController)
    -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - HomeTopViewDelegate

extension HomeViewController: HomeTopViewDelegate {
    func didTapCalendar() {
        let datePickerVC = DatePickerViewController(
            pickerMode: .date,
            pickerStyle: .inline,
            defaultDate: selectedDate
        )
        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.preferredContentSize = CGSize(width: 320, height: 320)

        datePickerVC.onDateSelected = { [weak self] date in
            guard let self = self else { return }
            self.selectedDate = date
            self.viewModel.filterReminders(for: date)
            dismiss(animated: true)
        }

        if let popoverPresentationController = datePickerVC.popoverPresentationController {
            popoverPresentationController.sourceView = topView.calendarImageView
            popoverPresentationController.sourceRect = topView.calendarImageView.bounds
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.delegate = self
            popoverPresentationController.backgroundColor = .systemBackground
        }

        present(datePickerVC, animated: true, completion: nil)
    }
}
