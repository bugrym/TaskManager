//
//  PersistenceManager.swift
//  TaskManager
//
//  Created by vbugrym on 03.07.2022.
//

import Foundation
import CoreData

typealias Completion = (() -> ())

protocol PersistenceStrategy: AnyObject {
    func fetchTask() -> [Task]
    func addTask(_ description: String, completion: @escaping ((Task?)->Void))
    func editTask(_ id: String, _ newDescription: String, completion: @escaping Completion)
    func deleteTask(_ id: String, completion: @escaping Completion)
}

final class PersistentManager: PersistenceStrategy {
    
    // MARK: - Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Fail to load PersistentStore with error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    // MARK: - Methods
    func fetchTask() -> [Task] {
        let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            
            let tasks = result.map {
                Task($0.id!,
                     Date(timeIntervalSinceReferenceDate: $0.creationalDate!.timeIntervalSinceReferenceDate),
                     $0.taskDescription!)
            }
            return tasks
        } catch {
            print("Couldn't get items from Core Data")
            return []
        }
    }
    
    func addTask(_ description: String, completion: @escaping ((Task?) -> Void)) {
        let context = persistentContainer.newBackgroundContext()
        
        let task = CoreDataTask(context: context)
        task.creationalDate = Date()
        task.id = UUID().uuidString
        task.taskDescription = description
        
        context.perform {
            do {
                try context.save()
                print("Task saved succesfully")
                if let id = task.id {
                    let result = Task(id, Date(), description)
                    completion(result)
                } else {
                    completion(nil)
                }
            } catch {
                context.rollback()
            }
        }
    }
    
    func editTask(_ id: String, _ newDescription: String, completion: @escaping Completion) {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        
        let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        context.perform {
            do {
                let result = try context.fetch(fetchRequest)
                
                if let objectToEdit = result.first {
                    objectToEdit.taskDescription = newDescription
                    
                    do {
                        try context.save()
                        completion()
                    } catch {
                        context.rollback()
                        print("Couldn't edit task")
                    }
                }
            } catch {
                context.rollback()
                print("Couldn't fetch task")
            }
        }
    }
    
    func deleteTask(_ id: String, completion: @escaping Completion) {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        
        let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        context.perform {
            do {
                let result = try context.fetch(fetchRequest)
                
                if let objectToDelete = result.first {
                    context.delete(objectToDelete)
                    do {
                        try context.save()
                        completion()
                    } catch {
                        context.rollback()
                        print("Couldn't delete task")
                    }
                }
            } catch {
                context.rollback()
                print("Couldn't fetch task")
            }
        }
    }
}
