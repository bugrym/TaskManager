//
//  AppCoordinator.swift
//  TaskManager
//
//  Created by vbugrym on 04.09.2022.
//

import UIKit

class AppCoordinator {
    
    // MARK: - Properties
    private let navigation = UINavigationController()
    
    var rootViewController: UIViewController {
        return navigation
    }
    
    // MARK: - Methods
    func start() {
        showAddTaskViewCtrl()
    }
    
    private func showAddTaskViewCtrl() {
        let addTaskViewCtrl = AddTaskViewController.instantiate()
        let viewModel = AddTaskViewModelImpl()
        
        addTaskViewCtrl.viewModel = viewModel
        
        viewModel.onShowListTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showTaskListViewCtrl()
        }
        
        navigation.pushViewController(addTaskViewCtrl, animated: true)
    }
    
    private func showTaskListViewCtrl() {
        let taskListViewCtrl = TaskListViewController.instantiate()
        let viewModel = TaskListViewModelImpl()
        let dataSource = TaskListDataSourceImpl(viewModel: viewModel)
        
        taskListViewCtrl.viewModel = viewModel
        taskListViewCtrl.dataSource = dataSource
        
        viewModel.onEditTask = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showEditTaskViewCtrl($0)
        }
        
        navigation.pushViewController(taskListViewCtrl, animated: true)
    }
    
    private func showEditTaskViewCtrl(_ task: Task) {
        let editTaskViewCtrl = EditTaskViewController.instantiate()
        let viewModel = EditTaskViewModelImpl(task)
        
        editTaskViewCtrl.viewModel = viewModel
        
        viewModel.onSuccessSave = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigation.popViewController(animated: true)
        }
        
        navigation.pushViewController(editTaskViewCtrl, animated: true)
    }
}
