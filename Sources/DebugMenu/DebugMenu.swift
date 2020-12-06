import UIKit

public struct DebugMenu {
    public static func install(windowScene: UIWindowScene? = nil, items: [DebugMenuPresentable]) {
        InAppDebuggerWindow.install(windowScene: windowScene, debuggerItems: items)
    }
}
