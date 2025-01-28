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
    func fetchReminders()
}

final class HomeViewController: UIViewController {

    // MARK: Properties

    private var viewModel: HomeViewModel {
        didSet {

            reminderTableView.reloadData()
        }
    }

    private var dates: [Date] { viewModel.dates }
    private var selectedDate = Date()
    private let dateManager = DateManager()
    private var name: String = "Mert"

    private lazy var dateCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 5, height: 48)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

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

    private lazy var addButton: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 56, weight: .regular)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 28
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAddButton)))
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

    deinit {
        NotificationCenter.default.removeObserver(self, name: .didCreateNewReminder, object: nil)
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReminders()
        configureView()
        topView.delegate = self
        viewModel.outputDelegate = self
        viewModel.filterReminders(for: selectedDate)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewReminderNotification(_:)),
            name: .didCreateNewReminder,
            object: nil
        )
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
        view.addSubview(dateCollectionView)
        view.addSubview(reminderTableView)
        view.addSubview(addButton)
    }

    func configureLayout() {
        dateCollectionView.setupAnchors(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            height: 48
        )
        reminderTableView.setupAnchors(
            top: dateCollectionView.bottomAnchor,
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

    func configureCollectionView() {
        if let flowLayout = dateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = dateCollectionView.bounds.width / 5
            flowLayout.itemSize = CGSize(width: width, height: dateCollectionView.bounds.height)
        }
    }

    func dateString(for index: Int) -> String {
        return dateManager.formatDate(dates[index])
    }
}

// MARK: - Objective Methods

private extension HomeViewController {
    @objc private func didTapAddButton() {
        let createVC = CreateViewController(initialDate: Date())
        createVC.modalPresentationStyle = .overFullScreen
        createVC.modalTransitionStyle = .crossDissolve
        present(createVC, animated: true, completion: nil)
    }

    @objc private func handleNewReminderNotification(_ notification: Notification) {
        guard let reminder = notification.object as? Reminder else { return }
        viewModel.inputDelegate?.addReminder(reminder)
        reloadData()
    }
}

// MARK: - HomeViewModelOutputProtocol

extension HomeViewController: HomeViewModelOutputProtocol {
    func fetchReminders() {
        viewModel.fetchReminders()
    }
    
    func updateRow(from oldIndex: Int, to newIndex: Int) {
        self.reminderTableView.moveRow(
            at: IndexPath(row: oldIndex, section: 0),
            to: IndexPath(row: newIndex, section: 0)
        )
        self.reloadData()
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
        DatePickerManager.shared.presentDatePicker(
            from: self,
            sourceView: topView.calendarImageView,
            initialDate: selectedDate,
            pickerMode: .date,
            pickerStyle: .inline,
            onDateSelected: { [weak self] date in
                guard let self else { return }
                self.selectedDate = date
                self.viewModel.filterReminders(for: date)
                dismiss(animated: true)
            }
        )
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {
            fatalError("Unable to dequeue DateCell")
        }
        let dateString = DateManager().formatDate(dates[indexPath.item])
        cell.configure(with: dateString)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
