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
    let persistentContainer: NSPersistentContainer
    
    static let shared: PersistenceStrategy = PersistentManager()
    
    // Init
    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreDataTask")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Fail to load PersistentStore with error: \(error.localizedDescription)")
            }
        }
    }
    
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
        let task = CoreDataTask(context: persistentContainer.viewContext)
        task.creationalDate = Date()
        task.id = UUID().uuidString
        task.taskDescription = description
        
        do {
            try persistentContainer.viewContext.save()
            print("Task saved succesfully")
            let result = Task(task.id!, Date(), description)
            completion(result)
        } catch {
            persistentContainer.viewContext.rollback()
            print("Couldn't save task")
            completion(nil)
        }
    }
    
    func editTask(_ id: String, _ newDescription: String, completion: @escaping Completion) {
        let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if let objectToEdit = result.first {
                objectToEdit.taskDescription = newDescription
                
                do {
                    try persistentContainer.viewContext.save()
                    completion()
                } catch {
                    persistentContainer.viewContext.rollback()
                    print("Couldn't edit task")
                }
            }
        } catch {
            persistentContainer.viewContext.rollback()
            print("Couldn't fetch task")
        }
    }
    
    func deleteTask(_ id: String, completion: @escaping Completion) {
        let fetchRequest: NSFetchRequest<CoreDataTask> = CoreDataTask.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            
            if let objectToDelete = result.first {
                persistentContainer.viewContext.delete(objectToDelete)
                
                do {
                    try persistentContainer.viewContext.save()
                    completion()
                } catch {
                    persistentContainer.viewContext.rollback()
                    print("Couldn't delete task")
                }
            }
        } catch {
            persistentContainer.viewContext.rollback()
            print("Couldn't fetch task")
        }
    }
}
