//
//  TaskListControllerTests.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/19/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import Foundation

import Nimble
import Quick
@testable import TodoList

class TaskListControllerTests: QuickSpec {
    override func spec() {
        describe("task list view controller") {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var taskListController: TaskListViewController!
            
            beforeEach {
                taskListController = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self)) as! TaskListViewController
                _ = taskListController.view
            }
            
            it("is instantiated") {
                expect(taskListController.listTable.numberOfSections) > 0
            }
            
            it("calls add item pressed") {
                taskListController.addItemPressed(UIBarButtonItem())

            }
            
            context("where the tableview") {
                
                let indexPath = IndexPath(row: 0, section: 0)
                
                it("can select rows") {
                    taskListController.listTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
                }
                
                
            }
            
        }
    }
}
