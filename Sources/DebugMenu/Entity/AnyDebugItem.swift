//
//  File.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/07.
//

import UIKit

struct AnyDebugItem: Hashable, Identifiable, DebugMenuPresentable {
    let id: String
    let debuggerItemTitle: String
    let action: DebugMenuAction
    
    init(_ item: DebugMenuPresentable) {
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
