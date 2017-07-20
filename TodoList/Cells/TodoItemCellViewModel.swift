//
//  TodoItemCellViewModel.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import UIKit

class TodoItemCellViewModel {
    fileprivate let todo: Todo

    //  MARK: - Life Cycle
    init(todo: Todo) {
        self.todo = todo
    }

    
    //  MARK: - Events
    var didSelectTodoItem: ((Todo) -> Void)?
    var didEditTodoItem: ((Todo) -> Void)?
    var didDeleteTodoItem: ((Todo) -> Void)?
    
    //  MARK: - Properties
    var taskDescription: String {
        return todo.task
    }
    
    var completed: Bool {
        return todo.completed
    }
    
    var id: Int {
        return todo.id
    }
}

extension TodoItemCellViewModel: CellRepresentable {
    func dequeue(from tableview: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: TodoItemCell.self)
        print(id)
        let cell = tableview.dequeueReusableCell(withIdentifier: id, for: indexPath) as! TodoItemCell
        cell.setup(viewModel: self)
        return cell
    }
    
    func cellWasSelected() {
        self.didSelectTodoItem?(self.todo)
    }
    
    func cellWasEdited() {
        self.didEditTodoItem?(self.todo)
    }
    
    func cellWasDeleted() {
        self.didDeleteTodoItem?(self.todo)
    }
}

