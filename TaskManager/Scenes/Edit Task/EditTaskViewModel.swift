//
//  EditTaskViewModel.swift
//  TaskManager
//
//  Created by vbugrym on 06.11.2022.
//

import Foundation

protocol EditTaskViewModel: AnyObject {
    var title: String { get }
    var description: String { get }
    var newDescription: String? { get set }
    var isSaveEnabled: Bool { get }
    var onSuccessSave: ActionClosure? { get set }
    var onValidateBtn: ActionClosure? { get set }
    
    func updateDescription(_ text: String)
    func saveChanges(completion: @escaping Completion)
}

final class EditTaskViewModelImpl: EditTaskViewModel {
    
    // MARK: - Properties
    var title: String { "Edit task" }
    var description: String { newDescription ?? task.description }
    var isSaveEnabled: Bool { task.description != description }
    var onSuccessSave: ActionClosure?
    var onValidateBtn: ActionClosure?
    var newDescription: String? {
        didSet {
            onValidateBtn?()
        }
    }
    
    private var task: Task
    
    // MARK: - Init
    init(_ task: Task) {
        self.task = task
    }
    
    // MARK: - Methods
    func updateDescription(_ text: String) {
        newDescription = text
    }
    
    func saveChanges(completion: @escaping Completion) {
        guard isSaveEnabled else { return }
        
        PersistentManager.shared.editTask(task.id, description) {
            completion()
        }
    }
}
