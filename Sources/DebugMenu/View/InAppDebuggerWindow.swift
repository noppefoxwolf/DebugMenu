import Combine
import UIKit

protocol TouchThrowing {}

@available(iOSApplicationExtension, unavailable)
public class InAppDebuggerWindow: UIWindow {
    internal static var windows: [InAppDebuggerWindow] = []

    internal static func install(
        windowScene: UIWindowScene? = nil,
        debuggerItems: [DebugItem],
        dashboardItems: [DashboardItem],
        options: [Options]
    ) {
        install(
            {
                windowScene.map(InAppDebuggerWindow.init(windowScene:))
                    ?? InAppDebuggerWindow(frame: UIScreen.main.bounds)
            },
            debuggerItems: debuggerItems,
            dashboardItems: dashboardItems,
            options: options
        )
    }

    internal override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }

    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private static func install(
        _ factory: (() -> InAppDebuggerWindow),
        debuggerItems: [DebugItem],
        dashboardItems: [DashboardItem],
        options: [Options]
    ) {
        let window = factory()
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.rootViewController = FloatingViewController(
            debuggerItems: debuggerItems,
            dashboardItems: dashboardItems,
            options: options
        )
        // workaround: Screen edge deferring is choose from full-screen windows.
        // -> preferredScreenEdgesDeferringSystemGestures
        window.frame.size.width += 1
        window.isHidden = false
        window.frame.size.width -= 1
        windows.append(window)
    }

    internal required init?(coder: NSCoder) { fatalError() }
    
    public override func makeKey() {
        // workaround: Make a new UIWindow without become key.
        // https://stackoverflow.com/a/64758605/1131587
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is TouchThrowing {
            return nil
        } else {
            return view
        }
    }
}
