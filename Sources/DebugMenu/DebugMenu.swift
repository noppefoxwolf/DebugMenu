import UIKit

@available(iOS 14, *)
public struct DebugMenu {
    public static func install(windowScene: UIWindowScene? = nil, items: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options] = []) {
        InAppDebuggerWindow.install(windowScene: windowScene, debuggerItems: items, complications: complications, options: options)
    }
}
