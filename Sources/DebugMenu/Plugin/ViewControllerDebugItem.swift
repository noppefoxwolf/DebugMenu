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
    
    public init(presentationMode: PresentationMode = .push, builder: @escaping ((T.Type) -> T) = { $0.init() }) {
        action = .didSelect { (controller, completions) in
            let viewController = builder(T.self)
            switch presentationMode {
            case .present:
                controller.present(viewController, animated: true, completion: {
                    completions(.success())
                })
            case .push:
                controller.navigationController?.pushViewController(viewController, animated: true)
                completions(.success())
            }
        }
    }
    
    public var debuggerItemTitle: String { String(describing: T.self) }
    public let action: DebugMenuAction
}
