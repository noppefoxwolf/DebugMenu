//
//  RangeDebugItem.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/18.
//

import Foundation

public struct RangeDebugItem: DebugMenuPresentable {
    public init(
        title: String,
        current: @escaping () -> Double,
        range: ClosedRange<Double> = 0.0...1.0,
        onChange: @escaping (Double) -> Void
    ) {
        self.title = title
        self.action = .slider(
            current: current,
            range: range,
            action: { (value, completions) in
                onChange(value)
                completions(.success())
            }
        )
    }

    let title: String
    public var debuggerItemTitle: String { title }
    public let action: DebugMenuAction
}
