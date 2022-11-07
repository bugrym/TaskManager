//
//  TaskCell.swift
//  TaskManager
//
//  Created by vbugrym on 07.10.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "TaskCell"
    
    // MARK: - IBOutles
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    // MARK: - Methods
    func configure(with task: Task) {
        dateLbl.text = DateTimeFormatter.timeString(from: task.creationalDate)
        descriptionLbl.text = task.description
    }
}
