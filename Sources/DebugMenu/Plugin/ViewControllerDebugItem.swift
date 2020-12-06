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
        self.presentationMode = presentationMode
        self.builder = builder
    }
    
    public var debuggerItemTitle: String { String(describing: T.self) }
    private let presentationMode: PresentationMode
    private let builder: (T.Type) -> T
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        let viewController = builder(T.self)
        switch presentationMode {
        case .present:
            controller.present(viewController, animated: true, completion: {
                completionHandler(.success())
            })
        case .push:
            controller.navigationController?.pushViewController(viewController, animated: true)
            completionHandler(.success())
        }
    }
}
