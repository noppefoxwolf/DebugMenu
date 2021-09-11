import UIKit

@available(iOSApplicationExtension, unavailable)
public struct DebugMenu {
    public static func install(
        windowScene: UIWindowScene? = nil,
        items: [DebugItem] = [],
        dashboardItems: [DashboardItem] = [],
        options: [Options] = Options.default
    ) {
        InAppDebuggerWindow.install(
            windowScene: windowScene,
            debuggerItems: items,
            dashboardItems: dashboardItems,
            options: options
        )
    }
}
