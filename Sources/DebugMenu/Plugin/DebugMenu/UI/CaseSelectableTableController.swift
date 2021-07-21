//
//  CaseSelectableTableController.swift
//  UI
//
//  Created by Tomoya Hirano on 2020/11/27.
//

import Foundation
import UIKit

public class CaseSelectableTableController<T: CaseIterable & RawRepresentable>:
    UITableViewController
where T.RawValue: Equatable {
    public let currentValue: T
    public let didSelected: (T) -> Void
    private var selectedIndex: IndexPath? = nil

    public init(currentValue: T, didSelected: @escaping (T) -> Void) {
        self.currentValue = currentValue
        self.didSelected = didSelected
        super.init(style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    required init?(coder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = IndexPath(
            row: T.allCases.enumerated().first(where: { $1 == currentValue })?.offset ?? 0,
            section: 0
        )
        tableView.tableFooterView = UIView()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        T.allCases.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let value = T.allCases.map({ $0 })[indexPath.row]
        cell.textLabel?.text = "\(value)"
        cell.accessoryType = (indexPath == selectedIndex) ? .checkmark : .none
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPathes: [IndexPath] = [indexPath, selectedIndex].compactMap({ $0 })
        selectedIndex = indexPath
        tableView.reloadRows(at: indexPathes, with: .automatic)
        let value = T.allCases.map({ $0 })[indexPath.row]
        didSelected(value)
    }
}
