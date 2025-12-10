import Foundation

public struct ToggleDebugItem: DebugItem {
    public init(
        title: String,
        current: @escaping @Sendable () -> Bool,
        onChange: @escaping @Sendable (Bool) -> Void
    ) {
        self.title = title
        self.action = .toggle(
            current: current,
            operation: { (isOn) in
                onChange(isOn)
                return .success()
            }
        )
    }

    let title: String
    public var debugItemTitle: String { title }
    public let action: DebugItemAction
}
