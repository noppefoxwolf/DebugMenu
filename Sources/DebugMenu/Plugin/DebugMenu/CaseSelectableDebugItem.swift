import UIKit

public struct CaseSelectableDebugItem<T: CaseIterable & RawRepresentable & Sendable>: DebugItem
where T.RawValue: Equatable {
    public init(currentValue: T, didSelected: @escaping @Sendable @MainActor (T) -> Void) {
        self.action = .didSelect { controller in
            let vc = CaseSelectableTableController<T>(
                currentValue: currentValue,
                didSelected: didSelected
            )
            controller.navigationController?.pushViewController(vc, animated: true)
            return .success()
        }
    }
    public var debugItemTitle: String { String(describing: T.self) }
    public let action: DebugItemAction
}
