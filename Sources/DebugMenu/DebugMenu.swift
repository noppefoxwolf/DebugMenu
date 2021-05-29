import UIKit

public struct DebugMenu {
    public static func install(windowScene: UIWindowScene? = nil, items: [DebugMenuPresentable], complications: [ComplicationPresentable]) {
        InAppDebuggerWindow.install(windowScene: windowScene, debuggerItems: items, complications: complications)
    }
}
