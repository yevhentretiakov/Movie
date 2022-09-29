//
//  BaseTableViewCell.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 20.09.2022.
//

import UIKit

// MARK: - Protocols
protocol TableCellRegistrable {
    static func registerNib(in tableView: UITableView)
    static func registerClass(in tableView: UITableView)
}

protocol TableCellDequeuable {
    static func cell(in tableView: UITableView, at indexPath: IndexPath) -> Self
}

class BaseTableViewCell: UITableViewCell, TableCellRegistrable, TableCellDequeuable {

}

// MARK: - CellRegistrable for TableView
extension TableCellRegistrable where Self: BaseTableViewCell  {
    static func registerNib(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: Self.self), bundle: nil), forCellReuseIdentifier: String(describing: Self.self))
    }
    
    static func registerClass(in tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: String(describing: Self.self))
    }
}

// MARK: - TableCellDequeuable
extension TableCellDequeuable {
    static func cell(in tableView: UITableView, at indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self), for: indexPath) as! Self
    }
}
