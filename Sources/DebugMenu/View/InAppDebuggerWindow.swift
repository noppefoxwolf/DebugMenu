//
//  InAppDebugger.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit
import Combine

protocol TouchThrowing {}

public class InAppDebuggerWindow: UIWindow {
    internal static var shared: InAppDebuggerWindow!
    
    internal static func install(windowScene: UIWindowScene? = nil, debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options]) {
        install({ windowScene.map(InAppDebuggerWindow.init(windowScene:)) ?? InAppDebuggerWindow(frame: UIScreen.main.bounds) }, debuggerItems: debuggerItems, complications: complications, options: options)
    }
    
    internal override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private static func install(_ factory: (() -> InAppDebuggerWindow), debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options]) {
        let keyWindow = UIApplication.shared.findKeyWindow()
        shared = factory()
        shared.windowLevel = UIWindow.Level.statusBar + 1
        shared.rootViewController = FloatingViewController(debuggerItems: debuggerItems, complications: complications, options: options)
        shared!.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()
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
