//
//  File.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/07.
//

import UIKit

struct AnyDebugItem: Hashable, Identifiable, DebugItem {
    let id: String
    let debuggerItemTitle: String
    let action: DebugItemAction

    init(_ item: DebugItem) {
        id = UUID().uuidString
        debuggerItemTitle = item.debuggerItemTitle
        action = item.action
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnyDebugItem, rhs: AnyDebugItem) -> Bool {
        lhs.id == rhs.id
    }
}
