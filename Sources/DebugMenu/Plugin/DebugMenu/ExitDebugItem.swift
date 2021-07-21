//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import Foundation

public struct ExitDebugItem: DebugMenuPresentable {
    public init() {
        self.action = .didSelect(action: { (_, _) in
            exit(0)
        })
    }

    public var debuggerItemTitle: String { "exit" }
    public let action: DebugMenuAction
}
