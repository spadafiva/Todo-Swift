//
//  TodoItemCellViewModelTests.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Nimble
import Quick
@testable import TodoList

class TodoItemCellViewModelTests: QuickSpec {
    
    override func spec() {
        describe("todo item cell view model") {
            let todo = Todo(task: "First Task", completed: false, id: 1)
            let model = TodoItemCellViewModel(todo: todo)
            
            context("when initialized with a todo") {
                
                
                it("should have a correct task description") {
                    expect(model.taskDescription).to(equal("First Task"))
                }
                
                it("should have an id of 1") {
                    expect(model.id).to(equal(1))
                }
                
                it("should have completed marked as false") {
                    expect(model.completed).to(beFalse())
                }
                
                context("when given a didSelectItem closure") {
                    it("correctly uses that closure") {
                    waitUntil(timeout: 2) { done in
                        
                        model.didSelectTodoItem = { selectedTodo in
                            expect(selectedTodo.id).to(equal(1))
                            done()
                            
                        }
                        
                        model.cellWasSelected()
                    }
                    }
                }
            }
        }
    }
    
}
