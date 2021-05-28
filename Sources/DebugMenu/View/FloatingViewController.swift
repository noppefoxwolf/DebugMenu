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
            
            let longPress = UILongPressGestureRecognizer()
            longPress.publisher(for: \.state).filter({ $0 == .began }).sink { [weak self] _ in
                self?.presentMenu()
            }.store(in: &cancellables)
            launchView.addGestureRecognizer(longPress)
            
            launchView.addAction(.init(handler: { [weak self] _ in
                guard let self = self else { return }
                let vc = InAppDebuggerViewController(debuggerItems: self.debuggerItems)
                let nc = UINavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .fullScreen
                let ac = CustomActivityViewController(controller: nc)
                ac.popoverPresentationController?.sourceView = self.launchView
                ac.popoverPresentationController?.delegate = self
                ac.presentationController?.delegate = self
                self.present(ac, animated: true, completion: nil)
            }))
        }
        
        widget: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            widgetView.addGestureRecognizer(gesture)
            gesture.moveInitialPosition(.topLeading)
        }
    }
    
    private func presentMenu() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: "Hide until next launch", style: .destructive, handler: { [weak self] _ in
            self?.launchView.isHidden = true
            self?.widgetView.isHidden = true
            self?.widgetView.stop()
            InAppDebuggerWindow.shared.needsThroughTouches = true
        }))
        if widgetView.isHidden {
            sheet.addAction(.init(title: "Show widget", style: .default, handler: { [weak self] _ in
                self?.widgetView.isHidden = false
                self?.widgetView.stop()
                self?.widgetView.start()
                InAppDebuggerWindow.shared.needsThroughTouches = true
            }))
        } else {
            sheet.addAction(.init(title: "Hide widget", style: .destructive, handler: { [weak self] _ in
                self?.widgetView.isHidden = true
                self?.widgetView.stop()
                InAppDebuggerWindow.shared.needsThroughTouches = true
            }))
        }
        sheet.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
            InAppDebuggerWindow.shared.needsThroughTouches = true
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag) {
            InAppDebuggerWindow.shared.needsThroughTouches = false
            completion?()
        }
    }
}

extension FloatingViewController: UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        InAppDebuggerWindow.shared.needsThroughTouches = true
    }
}
