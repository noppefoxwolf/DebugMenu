//
//  File.swift
//  File
//
//  Created by Tomoya Hirano on 2021/07/20.
//

import Foundation

public class GroupDebugItem: DebugMenuPresentable {
    public init(title: String, items: [DebugMenuPresentable]) {
        self.debuggerItemTitle = title
        self.items = items.map(AnyDebugItem.init)
    }
    
    public var debuggerItemTitle: String
    public var action: DebugMenuAction {
        .didSelect { [weak self] controller, completions in
            guard let self = self else {
                completions(.failure())
                return
            }
            let vc = InAppDebuggerViewController(title: self.debuggerItemTitle, debuggerItems: self.items, options: [])
            controller.navigationController?.pushViewController(vc, animated: true)
            completions(.success())
        }
    }
    internal let items: [AnyDebugItem]
}
