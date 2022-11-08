//
//  BaseViewModel.swift
//  TaskManager
//
//  Created by vbugrym on 08.11.2022.
//

import Foundation

class BaseViewModel {
    var serviceProvider: ServiceProvider
    
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
    }
}
