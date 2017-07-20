//
//  TodoItemCell.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {
    @IBOutlet internal var taskDescription: UILabel!
    
    func setup(viewModel: TodoItemCellViewModel) {
        self.taskDescription.text = viewModel.taskDescription
        self.accessoryType = viewModel.completed ? .checkmark : .none
    }
}
