//
//  Api.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Foundation

class Api {
    
    let todoApi: TodoApi
    
    init(todoApi: TodoApi = TodoApi()) {
        self.todoApi = todoApi
    }
    
    var todos: [Todo] = [
        Todo(task: "One", completed: false, id: 1),
        Todo(task: "Two", completed: false, id: 2)
        ]
    
    func getAllTodos(onSuccess: @escaping ([Todo]) -> Void, onError: @escaping (Error) -> Void) {
        todoApi.getTodos(completed: nil) { result in
            switch result {
                case .success(let updated):
                    self.todos = updated
                    onSuccess(updated)
                
            case .failure(let error):
                
                    onError(error)
            }
        }
    }
    
    func createTodo(_ todo: Todo, onSuccess: @escaping ([Todo]) -> Void, onError: @escaping (Error) -> Void) {
        todoApi.create(todo: todo) { result in
            switch result {
            case .success:
                self.getAllTodos(onSuccess: onSuccess, onError: onError)
                
            case .failure(let error):
                onError(error)

            }
        }
    }
    
    func changeCompletionOfTodo(_ todo: Todo, onSuccess: @escaping ([Todo]) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let index = todos.index(where: { $0.id == todo.id }) else {
            onError(TodoError.miscellaneous)
            return
        }
        
        todos[index].toggleCompleted()
        let todo = todos[index]
        
        updateTodo(todo, onSuccess: onSuccess, onError: onError)
    }
    
    func deleteTodo(_ todo: Todo, onSuccess: @escaping ([Todo]) -> Void, onError: @escaping (Error) -> Void) {
        
        todoApi.deleteTodo(id: todo.id) { result in
            switch result {
            case .success:
                self.getAllTodos(onSuccess: onSuccess, onError: onError)
                
            case .failure(let error):
                onError(error)
                
            }
        }
    
    }
    
    func updateTodo(_ todo: Todo, onSuccess: @escaping ([Todo]) -> Void, onError: @escaping (Error) -> Void) {
        
        todoApi.updateTodo(id: todo.id, description: todo.task, completed: todo.completed) { result in
            switch result {
            case .success:
                self.getAllTodos(onSuccess: onSuccess, onError: onError)
                
            case .failure(let error):
                onError(error)
            }
        }
    }

}
