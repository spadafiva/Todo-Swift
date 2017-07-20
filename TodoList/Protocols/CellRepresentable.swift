//
//  CellRepresentable.swift
//  TodoList
//
//  Created by Joseph Spadafora on 7/19/17.
//  Copyright © 2017 Swift Joe. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    func dequeue(from tableview: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func cellWasSelected()
}
