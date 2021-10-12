//
//  DebugMenuPresentable.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/07.
//

import UIKit

public protocol DebugItem {
    var debugItemTitle: String { get }
    var action: DebugItemAction { get }
}

public enum DebugItemAction {
    case didSelect(
        action: (_ controller: UIViewController, _ completions: @escaping (DebugMenuResult) -> Void)
            -> Void
    )
    case execute(action: (_ completions: @escaping (DebugMenuResult) -> Void) -> Void)
    case toggle(
        current: () -> Bool,
        action: (_ isOn: Bool, _ completions: @escaping (DebugMenuResult) -> Void) -> Void
    )
    case slider(
        current: () -> Double,
        valueLabel: () -> String,
        range: ClosedRange<Double>,
        action: (_ value: Double, _ completions: @escaping (DebugMenuResult) -> Void) -> Void
    )
}
