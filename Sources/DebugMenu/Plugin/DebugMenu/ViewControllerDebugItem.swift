//
//  ViewControllerDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/03.
//

import UIKit

public struct ViewControllerDebugItem<T: UIViewController>: DebugMenuPresentable {
    public enum PresentationMode {
        case present
        case push
    }

    public init(
        title: String? = nil,
        presentationMode: PresentationMode = .push,
        builder: @escaping ((T.Type) -> T) = { $0.init() }
    ) {
        debuggerItemTitle = title ?? String(describing: T.self)
        action = .didSelect { (controller, completions) in
            let viewController = builder(T.self)
            switch presentationMode {
            case .present:
                controller.present(
                    viewController,
                    animated: true,
                    completion: {
                        completions(.success())
                    }
                )
            case .push:
                controller.navigationController?.pushViewController(viewController, animated: true)
                completions(.success())
            }
        }
    }

    public let debuggerItemTitle: String
    public let action: DebugMenuAction
}
