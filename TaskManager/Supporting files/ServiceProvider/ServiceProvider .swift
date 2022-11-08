//
//  ServiceProvider .swift
//  TaskManager
//
//  Created by vbugrym on 08.11.2022.
//

import Foundation

protocol ServiceProvider {
    var persistenceManager: PersistenceStrategy { get }
}

final class ServiceProviderImpl: ServiceProvider {
    lazy var persistenceManager: PersistenceStrategy = {
        return PersistentManager()
    }()
}
