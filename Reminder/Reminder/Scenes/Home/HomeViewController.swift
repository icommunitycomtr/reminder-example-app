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
    private var name: String = "Mert"

    private lazy var topView = HomeTopView(name: name)
    private lazy var reminderTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReminderCell.self, forCellReuseIdentifier: ReminderCell.identifier)
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            reminderTableView.performBatchUpdates(
                {
                    self.reminderTableView.moveRow(
                        at: IndexPath(row: oldIndex, section: 0),
                        to: IndexPath(row: newIndex, section: 0)
                    )
                },
                completion: { _ in
                    self.reloadData()
                })
        }
    }

    func reloadData() {
        self.reminderTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reminders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as? ReminderCell else {
            fatalError("Unable to dequeue ReminderCell")
        }
        cell.configure(with: viewModel.reminders[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.inputDelegate?.toggleReminder(at: indexPath.row)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - HomeTopViewDelegate

extension HomeViewController: HomeTopViewDelegate {
    func didTapCalendar() {
        let datePickerVC = DatePickerViewController(pickerMode: .date, pickerStyle: .inline)
        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.preferredContentSize = CGSize(width: 320, height: 320)

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
