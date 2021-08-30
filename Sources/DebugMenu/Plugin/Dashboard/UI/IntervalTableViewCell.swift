//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import UIKit

class IntervalTableViewCell: UITableViewCell {
    let graph = IntervalView(frame: .null)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        graph.frame = .init(x: 0, y: 0, width: 64, height: 36)
        accessoryView = graph
        selectionStyle = .none
        textLabel?.textColor = .white
        textLabel?.adjustsFontSizeToFitWidth = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDurations(_ durations: [TimeInterval]) {
        graph.reload(durations: durations)
    }
}
