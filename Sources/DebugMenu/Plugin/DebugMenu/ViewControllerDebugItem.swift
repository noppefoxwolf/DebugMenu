import UIKit

public struct ViewControllerDebugItem<T: UIViewController>: DebugItem {
    public enum PresentationMode {
        case present
        case push
    }

    public init(
        title: String? = nil,
        presentationMode: PresentationMode = .push,
        builder: @escaping ((T.Type) -> T) = { $0.init() }
    ) {
        debugItemTitle = title ?? String(describing: T.self)
        action = .didSelect { controller in
            let viewController = builder(T.self)
            switch presentationMode {
            case .present:
                await controller.present(viewController, animated: true)
                return .success()
            case .push:
                await controller.navigationController?
                    .pushViewController(viewController, animated: true)
                return .success()
            }
        }
    }

    public let debugItemTitle: String
    public let action: DebugItemAction
}
