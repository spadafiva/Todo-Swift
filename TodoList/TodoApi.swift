//
//  TodoApi.swift
//  TodoHomemade
//
//  Created by Joseph Spadafora on 7/4/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation
import Moya


/// This class is a singleton class that uses a MoyaProvider based on the
/// TodoEndpoint enum to handle all the web requests.  Every request is called,
/// then processed using the extensions in the Result+TodoExtension to return
/// the data in the correct format.
class TodoApi {
    
    internal var endpoint = MoyaProvider<TodoEndpoint>()
    static let shared = TodoApi()
    
    func setTestEndpoint() {
        endpoint = MoyaProvider<TodoEndpoint>(stubClosure: MoyaProvider.immediatelyStub)
    }
    
    
    /// This retrieves the list of all of the todos
    ///
    /// - Parameters:
    ///   - completed: This retrieves all the todos if set to `nil`, or only the
    ///                completed if set to true and the pending if set to false
    ///   - completion: closure to execute with the results
    func getTodos(completed: Bool? = nil, completion: @escaping (TodoResult<[Todo]>) -> Void) {
        endpoint.request(.getTodos(completed: completed)) { result in
            completion(result.asTodoArray())
        }
    }
    
//    /// This retrieves a todo with a specific id if it exists
//    func getTodo(withId id: Int, completion: @escaping (TodoResult<Todo>) -> Void) {
//        endpoint.request(.getTodo(id: id)) { result in
//            completion(result.asTodo())
//        }
//    }
    
    /// This handles creating a new todo on the backend server
    func create(todo: Todo, completion: @escaping (TodoResult<Todo>) -> Void) {
        let target: TodoEndpoint =
            .createTodo(task: todo.task,
                        completed: todo.completed)
        
        endpoint.request(target) { result in
            completion(result.asTodo())
        }
    }
    
    /// This handles deleting a todo, this return a successful callback if the
    /// item was deleted or if the item at that id did not exist before the call
    func deleteTodo(id: Int, completion: @escaping (TodoResult<Bool>) -> Void) {
        endpoint.request(.deleteTodo(id: id)) { result in
            let validated = result.validated([String:Any].self)
            switch validated {
            case .success:
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// This updates the details for a given todo item
    func updateTodo(id: Int, description: String, completed: Bool, completion: @escaping (TodoResult<Todo>) -> Void) {
        let target: TodoEndpoint =
        .updateTodo(id: id, task: description, completed: completed)
        endpoint.request(target) { result  in
            completion(result.asTodo())
        }
    }
    
}
