//
//  InAppDebuggerPlugin.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/03.
//

import UIKit

public enum InAppDebuggerResult {
    case success(message: String? = nil)
    case failure(message: String? = nil)
}

public protocol DebugMenuPresentable {
    var debuggerItemTitle: String { get }
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void)
}
