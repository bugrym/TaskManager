//
//  AddTaskViewModel.swift
//  TaskManager
//
//  Created by vbugrym on 10.09.2022.
//

import Foundation

typealias ActionClosure = (() -> Void)
typealias ResultClosure = ((Bool) -> Void)

protocol AddTaskViewModel: AnyObject {
    var onValidateBtn: ActionClosure? { get set }
    var title: String { get }
    var isSaveEnabled: Bool { get }
    
    func updateDescription(_ text: String)
    func saveTask(completion: @escaping Completion)
}

final class AddTaskViewModelImpl: BaseViewModel, AddTaskViewModel {
    
    // MARK: - Properties
    var onValidateBtn: ActionClosure?
    var title: String { "Add new task" }
    var isSaveEnabled: Bool { !description.isEmpty }
    
    private var description: String = "" {
        didSet {
            onValidateBtn?()
        }
    }
    
    // MARK: - Initialization
    override init (serviceProvider: ServiceProvider) {
        super.init(serviceProvider: serviceProvider)
    }
    
    // MARK: - Methods
    func updateDescription(_ text: String) {
        description = text
    }
    
    func saveTask(completion: @escaping Completion) {
        serviceProvider.persistenceManager.addTask(description) { [weak self] _ in
            guard let strongSelf = self else { return }
                strongSelf.description = ""
            completion()
        }
    }
}
