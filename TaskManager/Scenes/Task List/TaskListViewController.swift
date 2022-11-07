//
//  TaskListViewController.swift
//  TaskManager
//
//  Created by vbugrym on 03.10.2022.
//

import UIKit

final class TaskListViewController: UITableViewController, Storyboardable {
    
    // MARK: - Properties
    var viewModel: TaskListViewModel!
    var dataSource: TaskListDataSource?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupTableView()
        setupRefreshControl()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTasks()
    }
    
    // MARK: - Methods
    private func setupNavigation() {
        navigationItem.title = viewModel.title
    }
    
    private func bind() {
        viewModel.onDataUpdate = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tableView.refreshControl?.endRefreshing()
            strongSelf.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addAction(UIAction { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                strongSelf.viewModel.fetchTasks()
            }
        }, for: .valueChanged)
    }
}
