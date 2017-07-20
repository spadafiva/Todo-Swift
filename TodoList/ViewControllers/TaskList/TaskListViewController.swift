//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/18/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    //  MARK: - Identifier Constants
    //  MARK: - Interface Builder Outlets
    @IBOutlet weak var listTable: UITableView!

    //  MARK: - Properties
    fileprivate var viewModel: TaskListViewModel! {
        didSet {
            bindToViewModel()
        }
    }
    
    //  MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TaskListViewModel()
        listTable.delegate = self
        listTable.dataSource = self
        
        viewModel.reloadData()
        
    }

    //  MARK: - Navigation
    //  MARK: - IBActions
    @IBAction func toggleCompletedPressed(_ sender: UIBarButtonItem) {
        self.viewModel.toggleCompleted()
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        self.viewModel.newTaskPressed()
    }

    //  MARK: - Helper Functions
    private func bindToViewModel() {
        
        self.viewModel.didUpdate = { [weak self] _ in
            self?.modelDidUpdate()
        }
        
        self.viewModel.shouldShowNewTodoPopup = { [weak self] _ in
            self?.showAddItemPopup()
        }
        
        modelDidUpdate()
        
    }
    
    private func modelDidUpdate() {
        DispatchQueue.main.async {
            self.listTable?.reloadData()
        }
    }
    
    private func showAddItemPopup() {
        let alertController = UIAlertController(title: "Add Item",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { $0.placeholder = "Enter new task..." }
        alertController.view.tintColor = .purple
        
        let addItemString =
            NSAttributedString(
                string: "Add Item",
                attributes: [
                    NSForegroundColorAttributeName: UIColor.purple
                ])
        
        alertController.setValue(addItemString, forKey: "attributedTitle")
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            let text = alertController.textFields?.first?.text
            self?.viewModel.createTodoWithTask(text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleSaveAction(_ alertAction: UIAlertAction) {
        
    }
}
//  MARK: - Delegates / Extensions


extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let hiding = self.viewModel.isHidingCompleted
        return hiding ? 1 : self.viewModel.todoViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.todoViewModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.viewModel.todoViewModels[indexPath.section][indexPath.row].dequeue(from: tableView, for: indexPath)
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.todoViewModels[indexPath.section][indexPath.row].cellWasSelected()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            self.viewModel.todoViewModels[indexPath.section][indexPath.row].cellWasDeleted()
        }
        
        return [delete]
    }
}
