//
//  FloatingViewController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/23.
//

import UIKit
import Combine

internal class FloatingViewController: UIViewController {
    private let launchView: LaunchView = .init()
    private let widgetView: WidgetView = .init()
    
    private let debuggerItems: [DebugMenuPresentable]
    private var cancellables: Set<AnyCancellable> = []
    
    init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(launchView)
        view.addSubview(widgetView)
        widgetView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bug: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            launchView.addGestureRecognizer(gesture)
            gesture.moveInitialPosition()
            
            setupMenu()
            
            launchView.addAction(.init(handler: { [weak self] _ in
                guard let self = self else { return }
                let vc = InAppDebuggerViewController(debuggerItems: self.debuggerItems)
                let nc = UINavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .fullScreen
                vc.delegate = self
                let ac = CustomActivityViewController(controller: nc)
                ac.popoverPresentationController?.sourceView = self.launchView
                ac.popoverPresentationController?.delegate = self
                self.present(ac, animated: true, completion: nil)
            }))
        }
        
        widget: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            widgetView.addGestureRecognizer(gesture)
            gesture.moveInitialPosition(.topLeading)
        }
    }
    
    private func setupMenu() {
        launchView.menu = makeMenu()
    }
    
    private func makeMenu() -> UIMenu {
        var children: [UIAction] = []
        let hide = UIAction(title: "Hide until next launch") { [weak self] _ in
            self?.launchView.isHidden = true
        }
        children.append(hide)
        if widgetView.isHidden {
            let widget = UIAction(title: "Show widget") { [weak self] action in
                self?.widgetView.isHidden = false
                self?.widgetView.stop()
                self?.widgetView.start()
                self?.setupMenu()
            }
            children.append(widget)
        } else {
            let widget = UIAction(title: "Hide widget") { [weak self] action in
                self?.widgetView.isHidden = true
                self?.widgetView.stop()
                self?.setupMenu()
            }
            children.append(widget)
        }
        
        return UIMenu(children: children)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            InAppDebuggerWindow.shared.needsThroughTouches = false
            completion?()
        }
    }
}

extension FloatingViewController: InAppDebuggerViewControllerDelegate {
    func didDismiss(_ controller: InAppDebuggerViewControllerBase) {
        InAppDebuggerWindow.shared.needsThroughTouches = true
    }
}

extension FloatingViewController: UIPopoverPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        InAppDebuggerWindow.shared.needsThroughTouches = true
    }
}
