//
//  File.swift
//  File
//
//  Created by Tomoya Hirano on 2021/07/20.
//

import Foundation

protocol HasDebugItems {
    var debugItems: [AnyGroupDebugItem] { get }
}

public struct GroupDebugItem: DebugItem, HasDebugItems {
    public init(title: String, items: [DebugItem]) {
        self.debugItemTitle = title
        self.debugItems = items.map(AnyGroupDebugItem.init)
    }

    public var debugItemTitle: String
    public var action: DebugItemAction {
        .didSelect { controller, completions in
            let vc = InAppDebuggerViewController(
                title: self.debugItemTitle,
                debuggerItems: self.debugItems,
                options: []
            )
            controller.navigationController?.pushViewController(vc, animated: true)
            completions(.success())
        }
    }
    let debugItems: [AnyGroupDebugItem]
}

struct AnyGroupDebugItem: Hashable, Identifiable, DebugItem, HasDebugItems {
    let id: String
    let debugItemTitle: String
    let action: DebugItemAction
    let debugItems: [AnyGroupDebugItem]

    init(_ item: DebugItem) {
        id = UUID().uuidString
        debugItemTitle = item.debugItemTitle
        action = item.action
        if let grouped = item as? HasDebugItems {
            debugItems = grouped.debugItems.map(AnyGroupDebugItem.init)
        } else {
            debugItems = []
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnyGroupDebugItem, rhs: AnyGroupDebugItem) -> Bool {
        lhs.id == rhs.id
    }
}

extension Array where Element == AnyGroupDebugItem {
    func flatten() -> [AnyGroupDebugItem] {
        var result: [AnyGroupDebugItem] = []
        for element in self {
            if element.debugItems.isEmpty {
                result.append(element)
            } else {
                result.append(element)
                result.append(contentsOf: element.debugItems.flatten())
            }
        }
        return result
    }
}
