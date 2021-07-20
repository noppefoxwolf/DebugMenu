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

public struct GroupDebugItem: DebugMenuPresentable, HasDebugItems {
    public init(title: String, items: [DebugMenuPresentable]) {
        self.debuggerItemTitle = title
        self.debugItems = items.map(AnyGroupDebugItem.init)
    }
    
    public var debuggerItemTitle: String
    public var action: DebugMenuAction {
        .didSelect { controller, completions in
            let vc = InAppDebuggerViewController(
                title: self.debuggerItemTitle,
                debuggerItems: self.debugItems,
                options: []
            )
            controller.navigationController?.pushViewController(vc, animated: true)
            completions(.success())
        }
    }
    let debugItems: [AnyGroupDebugItem]
}

struct AnyGroupDebugItem: Hashable, Identifiable, DebugMenuPresentable, HasDebugItems {
    let id: String
    let debuggerItemTitle: String
    let action: DebugMenuAction
    let debugItems: [AnyGroupDebugItem]
    
    init(_ item: DebugMenuPresentable) {
        id = UUID().uuidString
        debuggerItemTitle = item.debuggerItemTitle
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
