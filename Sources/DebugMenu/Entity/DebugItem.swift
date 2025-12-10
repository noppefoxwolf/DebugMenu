import UIKit

public protocol DebugItem: Sendable {
    var debugItemTitle: String { get }
    var action: DebugItemAction { get }
}

public enum DebugItemAction: Sendable {
    case didSelect(
        operation: @Sendable @MainActor (_ controller: UIViewController) async -> DebugMenuResult
    )
    case execute(_ operation: @Sendable () async -> DebugMenuResult)
    case toggle(
        current: @Sendable () -> Bool,
        operation: @Sendable (_ isOn: Bool) async -> DebugMenuResult
    )
    case slider(
        current: @Sendable () -> Double,
        valueLabelText: @Sendable (Double) -> String,
        range: ClosedRange<Double>,
        operation: @Sendable (_ value: Double) async -> DebugMenuResult
    )
}
