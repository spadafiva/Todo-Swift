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

class TodoItemCellTests: QuickSpec {
    
    override func spec() {
        describe("todo item cell") {
            context("when setup with a view model") {
                let cell = TodoItemCell()
                cell.taskDescription = UILabel()
                
                context("with an incomplete task") {
                    let todo = Todo(task: "Task", completed: false)
                    let model = TodoItemCellViewModel(todo: todo)
                    cell.setup(viewModel: model)
                    
                    it("has the correct description in the label") {
                        expect(cell.taskDescription.text).to(equal("Task"))
                    }
                    
                    it("has no accessory indicator") {
                        expect(cell.accessoryView).to(beNil())
                    }
                }
                
                context("with a completed task") {
                    let todo = Todo(task: "Task", completed: true)
                    let model = TodoItemCellViewModel(todo: todo)
                    cell.setup(viewModel: model)
                    
                    it("has the correct description in the label") {
                        expect(cell.taskDescription.text).to(equal("Task"))
                    }
                    
                    it("has a checkmark accessory indicator") {
                        expect(cell.accessoryType).to(equal(UITableViewCellAccessoryType.checkmark))
                    }
                }
                
            }
        }
    }
    
}
