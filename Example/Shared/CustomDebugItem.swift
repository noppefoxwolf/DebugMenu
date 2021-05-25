//
//  CustomDebugItem.swift
//  Example
//
//  Created by Tomoya Hirano on 2020/12/06.
//

import UIKit
import DebugMenu

public struct CustomDebugItem: DebugMenuPresentable {
    public init() {}
    public let debuggerItemTitle: String = "Custom item"
    public let action: DebugMenuAction = .toggle { UserDefaults.standard.bool(forKey: "key") } action: { (isOn, completions) in
        let userDefaults = UserDefaults.standard
        userDefaults.set(isOn, forKey: "key")
        if userDefaults.synchronize() {
            completions(.success(message: "Switch to \(isOn)"))
        } else {
            completions(.failure(message: "Failed to save"))
        }
    }
}
