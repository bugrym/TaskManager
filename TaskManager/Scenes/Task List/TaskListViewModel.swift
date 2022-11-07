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
    var title: String { get }
    
    func deleteTaskAt(_ indexPath: IndexPath)
    func editTaskAt(_ indexPath: IndexPath)
    func fetchTasks()
}

final class TaskListViewModelImpl: TaskListViewModel {
    
    // MARK: - Properties
    var dataSource: [Task] = [] {
        didSet {
            onDataUpdate?()
        }
    }
    
    var onDataUpdate: ActionClosure?
    var onEditTask: ((Task) -> Void)?
    var title: String { "Task list" }
    
    // MARK: - Methods
    func fetchTasks() {
        dataSource = PersistentManager.shared.fetchTask()
    }
    
    func deleteTaskAt(_ indexPath: IndexPath) {
        let taskId = dataSource[indexPath.row].id
        
        PersistentManager.shared.deleteTask(taskId) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dataSource.remove(at: indexPath.row)
        }
    }
    
    func editTaskAt(_ indexPath: IndexPath) {
        let task = dataSource[indexPath.row]
        onEditTask?(task)
    }
}
