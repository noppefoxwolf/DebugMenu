//
//  FloatingViewController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/23.
//

import UIKit
import Combine

internal class FloatingButton: UIButton {}

internal class FloatingViewController: UIViewController {
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
        
        floatingButton.addTarget(self, action: #selector(onTapFloatingButton), for: .touchUpInside)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            InAppDebuggerWindow.shared.needsThroughTouches = false
            completion?()
        }
    }
    
    @objc private func onTapFloatingButton(_ button: UIView) {
        let vc = InAppDebuggerViewController(debuggerItems: self.debuggerItems)
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        let ac = CustomActivityViewController(controller: nc)
        ac.popoverPresentationController?.sourceView = button
        self.present(ac, animated: true, completion: nil)
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
