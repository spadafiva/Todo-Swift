//
//  TaskListControllerViewModelTests.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/19/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Foundation

import Nimble
import Quick
@testable import TodoList

class TaskListControllerViewModelTests: QuickSpec {
    override func spec() {
        describe("Task list view model") {
            
            let stubApi = Api()
            stubApi.todoApi.setTestEndpoint()
            
            var model: TaskListViewModel!
            
            beforeEach {
                model = TaskListViewModel(api: stubApi)
            }
            
            context("when first initialized") {
                
                it("has an empty todo list") {
                    expect(model.todoViewModels.count).to(equal(2))
                    expect(model.todoViewModels[0].count).to(equal(0))
                    expect(model.todoViewModels[1].count).to(equal(0))
                }
                
                it("is hiding completed tasks") {
                    expect(model.isHidingCompleted).to(beTrue())
                }
                
                it("has empty event closures") {
                    expect(model.didError).to(beNil())
                    expect(model.didUpdate).to(beNil())
                    expect(model.shouldShowNewTodoPopup).to(beNil())
                    expect(model.didSelectTodo).to(beNil())
                    expect(model.didEditTodo).to(beNil())
                    expect(model.didDeleteTodo).to(beNil())
                }
            }
            
            
            it("calls didUpdate after reloading data") {
                waitUntil(timeout: 2) { done in
                    model.didUpdate = { _ in
                        done()
                    }
                    model.reloadData()
                }
            }
            
            
            it("calls show new popup when newTaskPressed is called") {
                waitUntil(timeout: 1) { done in
                    model.shouldShowNewTodoPopup = { _ in
                        done()
                    }
                    
                    model.newTaskPressed()
                }
            }
            
            
            it("toggles hiding and calls didUpdate when using toggleCompleted") {
                waitUntil(timeout: 1) { done in
                    model.didUpdate = { _ in
                        expect(model.isHidingCompleted).to(beFalse())
                        done()
                    }
                    
                    model.toggleCompleted()
                }
            }
            
            context("when creating todo with task string") {
                it("reloads with new data when given a valid string") {
                    waitUntil(timeout: 2) { done in
                        model.didUpdate = { _ in
                            done()
                        }
                        
                        model.createTodoWithTask("New Task")
                    }
                }
                
                it("emits the correct error when passed a nil task") {
                    waitUntil(timeout: 2) { done in
                        model.didError = { error in
                            
                            expect(error as? TaskListError)
                                .to(equal(TaskListError.missingTaskDescription))
                            
                            expect((error as! TaskListError).localizedDescription)
                                .to(equal(TaskListError.missingTaskDescription.localizedDescription))
                            
                            done()
                        }
                        
                        model.createTodoWithTask(nil)
                    }
                }
            }
            
            context("created view models closures are passed correctly") {
                
                beforeEach {
                    model.reloadData()
                }
                
                it("triggers updates when using a todoViewModel's selected") {
                    waitUntil(timeout: 2) { done in
                        model.didUpdate = { updatedModel in
                            done()

                        }
                        
                        let todoModel = model.todoViewModels.first?.first
                        expect(todoModel != nil).to(beTrue())
                        
                        todoModel?.cellWasSelected()
                        
                    }
                }
                
                it("triggers updates when using a todoViewModel's deleted") {
                    waitUntil(timeout: 2) { done in
                        model.didUpdate = { updatedModel in
                            done()
                            
                        }
                        
                        let todoModel = model.todoViewModels.first?.first
                        expect(todoModel != nil).to(beTrue())
                        
                        todoModel?.cellWasDeleted()
                        
                    }
                }

                it("triggers updates when using a todoViewModel's edited") {
                    waitUntil(timeout: 2) { done in
                        model.didUpdate = { updatedModel in
                            done()
                            
                        }
                        
                        let todoModel = model.todoViewModels.first?.first
                        expect(todoModel != nil).to(beTrue())
                        
                        todoModel?.cellWasEdited()
                        
                    }
                }

            }
        }
    }
}
