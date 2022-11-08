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
    private let serviceProvider: ServiceProvider
    
    var rootViewController: UIViewController {
        return navigation
    }
    
    // MARK: - Initialization
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
    
    // MARK: - Methods
    func start() {
        showTaskListViewCtrl()
    }
    
    private func showTaskListViewCtrl() {
        let taskListViewCtrl = TaskListViewController.instantiate()
        let viewModel = TaskListViewModelImpl(serviceProvider: serviceProvider)
        let dataSource = TaskListDataSourceImpl(viewModel: viewModel)
        
        taskListViewCtrl.viewModel = viewModel
        taskListViewCtrl.dataSource = dataSource
        
        viewModel.onEditTask = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showEditTaskViewCtrl($0)
        }
        
        viewModel.onAddNewTask = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showAddTaskViewCtrl()
        }
        
        navigation.pushViewController(taskListViewCtrl, animated: true)
    }
    
    private func showAddTaskViewCtrl() {
        let addTaskViewCtrl = AddTaskViewController.instantiate()
        let viewModel = AddTaskViewModelImpl(serviceProvider: serviceProvider)
        
        addTaskViewCtrl.viewModel = viewModel
        navigation.pushViewController(addTaskViewCtrl, animated: true)
    }
    
    private func showEditTaskViewCtrl(_ task: Task) {
        let editTaskViewCtrl = EditTaskViewController.instantiate()
        let viewModel = EditTaskViewModelImpl(serviceProvider: serviceProvider, task: task)
        
        editTaskViewCtrl.viewModel = viewModel
        
        viewModel.onSuccessSave = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigation.popViewController(animated: true)
        }
        
        navigation.pushViewController(editTaskViewCtrl, animated: true)
    }
}
