//
//  Storyboardable.swift
//  TaskManager
//
//  Created by vbugrym on 10.09.2022.
//

import UIKit

protocol Storyboardable: AnyObject {
    static var storyboardName: String { get }
    static var storyboardBundle: Bundle { get }
    static var storyboardId: String { get }
    
    static func instantiate() -> Self
}

// Provides a default implementation of the protocol
extension Storyboardable where Self: UIViewController {
    static var storyboardName: String {
        return "Main"
    }
    
    static var storyboardBundle: Bundle {
        return .main
    }
    
    static var storyboardId: String {
        String(describing: self)
    }
    
    static func instantiate() -> Self {
        guard let viewCtrl = UIStoryboard(name: storyboardName, bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardId) as? Self else {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardId)")
        }
        return viewCtrl
    }
}
