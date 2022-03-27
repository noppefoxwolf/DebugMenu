import UIKit

public struct UserDefaultsResetDebugItem: DebugItem {
    public init() {}

    public let debugItemTitle: String = "Reset UserDefaults"

    public let action: DebugItemAction = .execute {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        exit(0)
    }
}
