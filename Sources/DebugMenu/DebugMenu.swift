import UIKit

@available(iOSApplicationExtension, unavailable)
public struct DebugMenu {
    public static func install(windowScene: UIWindowScene? = nil, items: [DebugMenuPresentable] = [], complications: [ComplicationPresentable] = [], options: [Options] = Options.default) {
        InAppDebuggerWindow.install(windowScene: windowScene, debuggerItems: items, complications: complications, options: options)
    }
}
