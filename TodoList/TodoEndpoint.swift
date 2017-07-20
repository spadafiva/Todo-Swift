//
//  TodoEndpoint.swift
//  TodoHomemade
//
//  Created by Joseph Spadafora on 7/4/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation
import Moya

/// This represents all of the different endpoint targets with their paremeters
enum TodoEndpoint {
    case getTodos(completed: Bool?)
    case getTodo(id: Int)
    case createTodo(task: String, completed: Bool)
    case deleteTodo(id: Int)
    case updateTodo(id: Int, task: String, completed: Bool)
}

/// This makes the enum conform to the "TargetType" to be useable by Moya
extension TodoEndpoint: TargetType {
    
    var baseURL: URL {
        guard let urlString = try? PlistValue<String>(key: "baseUrl").value else {
            fatalError("No Keys.plist file or no key found")
        }
        
        return URL(string: urlString)!
    }
    
    var path: String {
        switch self {
        case .getTodos, .createTodo: return "/todos"
        case .getTodo(id: let id),
             .deleteTodo(id: let id),
             .updateTodo(id: let id, _, _): return "/todos/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTodo, .getTodos: return .get
        case .createTodo: return .post
        case .deleteTodo: return .delete
        case .updateTodo: return .put
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getTodos(completed: let completed):
            if let completed = completed {
                let params =  ["completed": completed]
                return params
            } else {
                return nil
            }
            
        case .getTodo, .deleteTodo: return nil
            
        case .updateTodo(id: _, task: let task, completed: let complete),
             .createTodo(task: let task, completed: let complete):
            
            return [Todo.K.completed: complete, Todo.K.task: task]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getTodo, .getTodos, .deleteTodo:
            return URLEncoding.default
        
        case .createTodo, .updateTodo:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getTodos: return "[{\"id\":25,\"description\":\"Do more stuff again\",\"completed\":false},{\"id\":28,\"description\":\"A new one 1\",\"completed\":false},{\"id\":26,\"description\":\"Do cool things still\",\"completed\":false}]".asUtfData
            
        case .getTodo,
             .createTodo,
             .updateTodo:
            return "{\"id\":25,\"description\":\"Do more stuff again\",\"completed\":false}".asUtfData
            
        case .deleteTodo: return "{}".asUtfData
        }
    }
    
    var task: Task {
        return .request
    }
}

extension String {
    var asUtfData: Data {
        return self.data(using: .utf8)!
    }
}
