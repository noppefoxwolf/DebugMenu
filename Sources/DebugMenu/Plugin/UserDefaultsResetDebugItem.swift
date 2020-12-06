//
//  UserDefaultsResetDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/06/08.
//

import UIKit

public struct UserDefaultsResetDebugItem: DebugMenuPresentable {
    public init() {}
    
    public var debuggerItemTitle: String { "Reset UserDefaults" }
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        exit(0)
    }
}
