//
//  Result+TodoExtension.swift
//  TodoHomemade
//
//  Created by Joseph Spadafora on 7/4/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation
import Moya
import Result

typealias TodoResult<T> = Result<T, TodoError>

extension Result where T == Response {
    
    /// This attempts to cast the result to an array of [Todos] or passes
    /// the failure response on.
    func asTodoArray() -> TodoResult<[Todo]>{
        switch self.validated([[String: Any]].self) {
        case .success(let todosJson):
            let todos = todosJson.flatMap({ Todo(json: $0) })
            return(.success(todos))
            
        case .failure(let error):
            return(.failure(error))
        }
    }
    
    
    /// This convenience function returns the result after checking if
    /// it can be case to a todo.
    func asTodo() -> TodoResult<Todo>{
        switch self.validated([String:Any].self) {
        case .success(let todoJson):
            if let todo = Todo(json: todoJson) {
                return(.success(todo))
            } else {
                return(.failure(TodoError.invalidOrEmptyData(nil)))
            }
            
        case .failure(let error):
            return(.failure(error))
        }
        
    }
    
    
    /// This function is a generic function that validates a response,
    /// it checks the MoyaResponse (basically a `Result` as used by Moya and
    /// Alamofire.  If the result is failure, it returns that error and passes
    /// it down the result chain.  Otherwise it validates the status code
    /// and then attempts to cast the result to the correct type.
    func validated<JSONResultType>(_ type: JSONResultType.Type) -> TodoResult<JSONResultType> {
        switch self {
        case .failure(let error):
            return .failure(TodoError.moyaError(error as! MoyaError))
            
        case .success(let response):
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                return .failure(.badStatusCode(response.statusCode))
            }
            
            do {
                if let responseJson = try response.mapJSON() as? JSONResultType {
                    return .success(responseJson)
                }  else {
                    return.failure(.invalidOrEmptyData(nil))
                }
                
                
            } catch {
                return .failure(.invalidOrEmptyData(nil))
            }
        }
    }
}
