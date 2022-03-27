import UIKit
import DebugMenu

public struct CustomDebugItem: DebugItem {    
    public init() {}
    public let debugItemTitle: String = "Custom item"
    public let action: DebugItemAction = .toggle { UserDefaults.standard.bool(forKey: "key") } operation: { isOn in
        let userDefaults = UserDefaults.standard
        userDefaults.set(isOn, forKey: "key")
        if userDefaults.synchronize() {
            return .success(message: "Switch to \(isOn)")
        } else {
            return .failure(message: "Failed to save")
        }
    }
}
