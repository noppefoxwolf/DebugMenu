//
//  UserDefaultsResetDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/06/08.
//

import UIKit

public struct UserDefaultsResetDebugItem: DebugMenuPresentable {
    public init() {}

    public let debuggerItemTitle: String = "Reset UserDefaults"

    public let action: DebugMenuAction = .execute { (_) in
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        exit(0)
    }
}
