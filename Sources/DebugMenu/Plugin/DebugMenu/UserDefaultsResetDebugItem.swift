//
//  UserDefaultsResetDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/06/08.
//

import UIKit

public struct UserDefaultsResetDebugItem: DebugItem {
    public init() {}

    public let debugItemTitle: String = "Reset UserDefaults"

    public let action: DebugItemAction = .execute { (_) in
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        exit(0)
    }
}
