//
//  InAppDebugger.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

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
        let keyWindow = UIApplication.shared.findKeyWindow()
        let window = factory()
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.rootViewController = FloatingViewController(
            debuggerItems: debuggerItems,
            dashboardItems: dashboardItems,
            options: options
        )
        // visible時にディスプレイサイズと同じサイズだとスクリーンエッジの設定を決める対象に選ばれるので避ける
        window.frame.size.width += 1
        window.makeKeyAndVisible()
        window.frame.size.width -= 1

        keyWindow?.makeKeyAndVisible()
        windows.append(window)
    }

    internal required init?(coder: NSCoder) { fatalError() }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is TouchThrowing {
            return nil
        } else {
            return view
        }
    }
}
