//
//  TodoListTests.swift
//  TodoListTests
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Nimble
import Quick
@testable import TodoList

class TodoItemTests: QuickSpec {
    override func spec() {
        describe("todo item") {
            var todo: Todo!
            
            
            context("after being initialized") {
                beforeEach {
                    todo = Todo(task: "New Item", completed: false)
                }
                
                it("should have 0 as a default id") {
                    expect(todo.id).to(equal(0))
                }
                
                it("should have New Item as the task") {
                    expect(todo.task).to(equal("New Item"))
                }
                
                it("should be incomplete (completed = false)") {
                    expect(todo.completed).to(equal(false))
                }
                
                context("when modified") {
                    beforeEach {
                        todo.toggleCompleted()
                        todo.task = "Different"
                        todo.id = 1
                    }
                    
                    it("should show completed after being toggled") {
                        expect(todo.completed).to(equal(true))
                    }
                    
                    it("should show Different tasks when modified") {
                        expect(todo.task).to(equal("Different"))
                    }
                    
                    it("should have an id of 1") {
                        expect(todo.id).to(equal(1))
                    }
                }
                
            }
            
            
            context("after being passed correct json data") {
                beforeEach {
                    todo = Todo(json: ["description": "task", "completed": false, "id": 1])
                }

                it("should have a task 'task'") {
                    expect(todo.task).to(equal("task"))
                }
                
                it("should have an id of 1") {
                    expect(todo.id).to(equal(1))
                }
                
                it("should be incomplete") {
                    expect(todo.completed).to(equal(false))
                }
                
                it("should return matching json") {
                    expect(todo.jsonValue["description"] as? String).to(equal("task"))
                    expect(todo.jsonValue["completed"] as? Bool).to(equal(false))
                    expect(todo.jsonValue["id"] as? Int).to(equal(1))
                }
            }
            
            
            
            context("when passed incorrect json") {
                beforeEach {
                    todo = Todo(json: ["completed": false, "id": 1])

                }
                
                it("should be nil") {
                    expect(todo).to(beNil())
                }
            }
            
        }
    }
}
