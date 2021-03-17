//
//  ConsoleDebugItem.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2021/02/25.
//

import Foundation

public struct ConsoleDebugItem: DebugMenuPresentable {
    public var debuggerItemTitle: String { "Console" }
    public let action: DebugMenuAction = .didSelect { (controller, completions) in
        let vc = LogsViewController()
        controller.navigationController?.pushViewController(vc, animated: true)
        completions(.success())
    }
    public init() {}
}
