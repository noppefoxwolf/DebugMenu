//
//  CustomDebugItem.swift
//  Example
//
//  Created by Tomoya Hirano on 2020/12/06.
//

import UIKit
import DebugMenu

struct CustomDebugItem: DebugMenuPresentable {
    let debuggerItemTitle: String = "Custom item"
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        completionHandler(.success(message: "OK"))
    }
}
