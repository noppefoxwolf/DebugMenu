import UIKit

public protocol DebugItem {
    var debugItemTitle: String { get }
    var action: DebugItemAction { get }
}

public enum DebugItemAction {
    case didSelect(
        operation: (_ controller: UIViewController) async -> DebugMenuResult
    )
    case execute(_ operation: () async -> DebugMenuResult)
    case toggle(
        current: () -> Bool,
        operation: (_ isOn: Bool) async -> DebugMenuResult
    )
    case slider(
        current: () -> Double,
        valueLabelText: (Double) -> String,
        range: ClosedRange<Double>,
        operation: (_ value: Double) async -> DebugMenuResult
    )
}
