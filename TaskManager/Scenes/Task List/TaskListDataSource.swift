//
//  TaskListDataSource.swift
//  TaskManager
//
//  Created by vbugrym on 07.10.2022.
//

import UIKit

protocol TaskListDataSource: UITableViewDelegate, UITableViewDataSource { }

final class TaskListDataSourceImpl: NSObject, TaskListDataSource {
    private let viewModel: TaskListViewModel
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
    }
}

extension TaskListDataSourceImpl {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.deleteTaskAt(indexPath)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] (_, _, completion) in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.editTaskAt(indexPath)
        }
        editAction.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [editAction])
    }
}
