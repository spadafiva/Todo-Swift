//
//  TaskListViewModel.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Foundation


class TaskListViewModel {
    //  MARK: - Singleton Objects
    //  MARK: - Constants
    //  MARK: - Properties
    private let api: Api
    private var completed: [TodoItemCellViewModel] = []
    private var pending: [TodoItemCellViewModel] = []
    
    var todoViewModels: [[TodoItemCellViewModel]] = [[],[]] {
        didSet {
            didUpdate?(self)
        }
    }
    var isHidingCompleted: Bool = true

    //  MARK: - Events
    var didUpdate: ((TaskListViewModel) -> Void)?
    var didError: ((Error) -> Void)?
    var shouldShowNewTodoPopup: ((TaskListViewModel) -> Void)?

    var didSelectTodo: ((Todo) -> Void)?
    var didEditTodo: ((Todo) -> Void)?
    var didDeleteTodo: ((Todo) -> Void)?
    
    //  MARK: - Initializers
    init(api: Api = Api()) {
        self.api = api
    }
    //  MARK: - Methods
    func createTodoWithTask(_ task: String?) {
        guard let task = task else {
            didError?(TaskListError.missingTaskDescription)
            return
        }
        
        let newTodo = Todo(task: task, completed: false)
        api.createTodo(newTodo, onSuccess: handleUpdatedTodos, onError: handleError)
        
    }
    
    func reloadData() {
        api.getAllTodos(onSuccess: handleUpdatedTodos, onError: handleError)
    }
    
    func newTaskPressed() {
        shouldShowNewTodoPopup?(self)
    }
    
    func toggleCompleted() {
        isHidingCompleted = !isHidingCompleted
        didUpdate?(self)
    }
    
    //  MARK: - Static Functions
    //  MARK: - Helper Functions
    private func handleUpdatedTodos(_ updatedTodos: [Todo]) {
        let allModels = updatedTodos.map({ modelFor(todo: $0) })
        completed = allModels.filter({ $0.completed })
        pending = allModels.filter({ !$0.completed })
        todoViewModels = [pending, completed]
    }
    
    private func handleError(_ error: Error) {
        didError?(error)
    }
    
    private func modelFor(todo: Todo) -> TodoItemCellViewModel {
        let newModel = TodoItemCellViewModel(todo: todo)
        
        newModel.didSelectTodoItem = { [weak self] todo in
            if let strongSelf = self {
                strongSelf.api.changeCompletionOfTodo(todo, onSuccess: strongSelf.handleUpdatedTodos, onError: strongSelf.handleError)
            }
        }
        
        newModel.didDeleteTodoItem = { [weak self] todo in
            if let strongSelf = self {
                strongSelf.api.deleteTodo(todo, onSuccess: strongSelf.handleUpdatedTodos(_:), onError: strongSelf.handleError(_:))
            }
        }
        
        newModel.didEditTodoItem = { [weak self] todo in
            if let strongSelf = self {
                strongSelf.api.deleteTodo(todo, onSuccess: strongSelf.handleUpdatedTodos(_:), onError: strongSelf.handleError(_:))
            }
        }
        
        
        return newModel
    }
}

enum TaskListError: Error {
    case missingTaskDescription
    
    var localizedDescription: String {
        switch  self {
        case .missingTaskDescription:
            return "No description was found for the new task."
        }
    }
}
