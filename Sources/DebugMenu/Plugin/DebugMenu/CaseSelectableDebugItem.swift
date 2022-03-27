import UIKit

public struct CaseSelectableDebugItem<T: CaseIterable & RawRepresentable>: DebugItem
where T.RawValue: Equatable {
    public init(currentValue: T, didSelected: @escaping (T) -> Void) {
        self.action = .didSelect { controller in
            let vc = await CaseSelectableTableController<T>(
                currentValue: currentValue,
                didSelected: didSelected
            )
            await controller.navigationController?.pushViewController(vc, animated: true)
            return .success()
        }
    }
    public var debugItemTitle: String { String(describing: T.self) }
    public let action: DebugItemAction
}
