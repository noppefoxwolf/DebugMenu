//
//  UIApplication+.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/23.
//

import UIKit

@available(iOSApplicationExtension, unavailable)
extension UIApplication {
    func findKeyWindow() -> UIWindow? {
        (connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows ?? windows)
            .filter({ !($0 is InAppDebuggerWindow) })
            .filter({$0.isKeyWindow}).first
    }
}
