//
//  TaskListViewModel.swift
//  TaskManager
//
//  Created by vbugrym on 07.10.2022.
//

import Foundation

protocol TaskListViewModel: AnyObject {
    var dataSource: [Task] { get }
    var onDataUpdate: ActionClosure? { get set }
    var onEditTask: ((Task) -> Void)? { get set }
    var onAddNewTask: ActionClosure? { get set }
    var title: String { get }
    var barBtnTitle: String { get }
    
    func fetchTasks() 
    func deleteTaskAt(_ indexPath: IndexPath)
    func editTaskAt(_ indexPath: IndexPath)
}

final class TaskListViewModelImpl: BaseViewModel, TaskListViewModel {
    
    // MARK: - Properties
    var dataSource: [Task] = [] {
        didSet {
            onDataUpdate?()
        }
    }
    
    var onDataUpdate: ActionClosure?
    var onAddNewTask: ActionClosure?
    var onEditTask: ((Task) -> Void)?
    var title: String { "Task list" }
    var barBtnTitle: String { "Add task" }
    
    // MARK: - Initialization
    override init (serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
    }
    
    // MARK: - Methods
    func fetchTasks() {
        dataSource = serviceProvider.persistenceManager.fetchTask()
    }
    
    func deleteTaskAt(_ indexPath: IndexPath) {
        let taskId = dataSource[indexPath.row].id
        
        serviceProvider.persistenceManager.deleteTask(taskId) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.remove(at: indexPath.row)
        }
    }
    
    func editTaskAt(_ indexPath: IndexPath) {
        let task = dataSource[indexPath.row]
        onEditTask?(task)
    }
}
