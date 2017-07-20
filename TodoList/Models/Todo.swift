//
//  Todo.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Foundation

class Todo: CustomStringConvertible {
    //  MARK: - Properties
    /// The id as returned by the back end server
    var id: Int
    
    
    /// What the todo is a reminder to do, string value
    var task: String
    
    
    /// False when the todo is still pending
    var completed: Bool
    
    
    /// JSON dictionary representation of the todo
    var jsonValue: [String: Any] {
        return [
            K.id: id,
            K.task: task,
            K.completed: completed
        ]
    }
    
    
    /// Custom String Convertible Description
    var description: String {
        return "\(jsonValue)"
    }
    
    
    //  MARK: - Methods
    func toggleCompleted() {
        completed = !completed
    }
    
    //  MARK: - Initializers
    init(task: String, completed: Bool, id: Int = 0) {
        self.id = id
        self.task = task
        self.completed = completed
    }
    
    
    convenience init?(json: [String: Any]) {
        guard let description = json[K.task] as? String,
            let completed = json[K.completed] as? Bool,
            let id = json[K.id] as? Int else { return nil }
        self.init(task: description, completed: completed, id: id)
    }
    
    //  MARK: - Associated Values
    
    /// This holds all of the string keys for the model to avoid string
    /// error typos.
    struct K {
        static let task = "description"
        static let completed = "completed"
        static let id = "id"
    }
}
