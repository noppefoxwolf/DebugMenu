//
//  InAppDebugger.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit
import Combine

public class InAppDebuggerWindow: UIWindow {
    internal static var shared: InAppDebuggerWindow!
    internal var needsThroughTouches: Bool = true
    
    internal static func install(windowScene: UIWindowScene? = nil, debuggerItems: [DebugMenuPresentable]) {
        install({ windowScene.map(InAppDebuggerWindow.init(windowScene:)) ?? InAppDebuggerWindow(frame: UIScreen.main.bounds) }, debuggerItems: debuggerItems)
    }
    
    internal override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private static func install(_ factory: (() -> InAppDebuggerWindow), debuggerItems: [DebugMenuPresentable]) {
        let keyWindow = UIApplication.shared.findKeyWindow()
        shared = factory()
        shared.windowLevel = UIWindow.Level.statusBar + 1
        shared.rootViewController = FloatingViewController(debuggerItems: debuggerItems)
        shared!.makeKeyAndVisible()
        keyWindow?.makeKeyAndVisible()
    }
    
    internal required init?(coder: NSCoder) { fatalError() }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if InAppDebuggerWindow.shared.needsThroughTouches {
            return super.hitTest(point, with: event) as? FloatingButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

protocol InAppDebuggerViewControllerDelegate: AnyObject {
    func didDismiss(_ controller: InAppDebuggerViewControllerBase)
}

open class InAppDebuggerViewControllerBase: UIViewController {
    weak var delegate: InAppDebuggerViewControllerDelegate? = nil
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.didDismiss(self)
            completion?()
        })
    }
}

