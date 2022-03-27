import Foundation

public struct ExitDebugItem: DebugItem {
    public init() {
        self.action = .didSelect(operation: { _ in
            exit(0)
        })
    }

    public var debugItemTitle: String { "exit" }
    public let action: DebugItemAction
}
