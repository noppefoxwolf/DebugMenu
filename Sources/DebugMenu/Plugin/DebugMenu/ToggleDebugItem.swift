//
//  ToggleDebugItem.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/18.
//

import Foundation

public struct ToggleDebugItem: DebugMenuPresentable {
    public init(title: String, current: @escaping () -> Bool, onChange: @escaping (Bool) -> Void) {
        self.title = title
        self.action = .toggle(
            current: current,
            action: { (isOn, completions) in
                onChange(isOn)
                completions(.success())
            }
        )
    }

    let title: String
    public var debuggerItemTitle: String { title }
    public let action: DebugMenuAction
}
