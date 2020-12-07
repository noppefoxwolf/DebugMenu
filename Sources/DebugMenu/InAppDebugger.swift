//
//  InAppDebugger.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit
import Combine

public class InAppDebuggerWindow: UIWindow {
    fileprivate static var shared: InAppDebuggerWindow!
    fileprivate var needsThroughTouches: Bool = true
    
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

fileprivate class FloatingButton: UIButton {}

fileprivate class FloatingViewController: UIViewController {
    private let floatingView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    private let floatingButton: FloatingButton = FloatingButton(frame: .zero)
    private let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    private let debuggerItems: [DebugMenuPresentable]
    private var cancellables: Set<AnyCancellable> = []
    
    init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        floatingView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        view.addSubview(floatingView)
        
        let image = UIImage(systemName: "ant.fill")
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = UIColor.white
        floatingView.contentView.addSubview(floatingButton)
        floatingButton.frame = floatingView.bounds
        floatingView.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = FloatingItemGestureRecognizer(groundView: self.view)
        floatingView.addGestureRecognizer(gesture)
        longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
        
        floatingView.addGestureRecognizer(longPressGesture)
        
        self.floatingView.layer.cornerCurve = .continuous
        self.floatingView.layer.cornerRadius = 22
        self.floatingView.layer.masksToBounds = true
        
        gesture.moveInitialPosition()
        
        floatingButton.addTarget(self, action: #selector(onTapFloatingView), for: .touchUpInside)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            InAppDebuggerWindow.shared.needsThroughTouches = false
            completion?()
        }
    }
    
    @objc private func onTapFloatingView() {
        let vc = InAppDebuggerViewController(debuggerItems: self.debuggerItems)
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(nc, animated: true, completion: nil)
    }
    
    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        floatingView.alpha = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.floatingView.alpha = 1.0
        }
        let feedback = UIImpactFeedbackGenerator(style: .rigid)
        feedback.prepare()
        feedback.impactOccurred()
    }
}

extension FloatingViewController: InAppDebuggerViewControllerDelegate {
    func didDismiss(_ controller: InAppDebuggerViewControllerBase) {
        InAppDebuggerWindow.shared.needsThroughTouches = true
    }
}

protocol InAppDebuggerViewControllerDelegate: class {
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


extension UIApplication {
    func findKeyWindow() -> UIWindow? {
        (connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows ?? windows)
            .filter({ !($0 is InAppDebuggerWindow) })
            .filter({$0.isKeyWindow}).first
    }
}
