//
//  FloatingViewController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/23.
//

import UIKit
import Combine

@available(iOS 14, *)
internal class FloatingViewController: UIViewController {
    class View: UIView, TouchThrowing {}
    private let launchView: LaunchView = .init()
    private let widgetView: WidgetView
    private let debuggerItems: [DebugMenuPresentable]
    private var cancellables: Set<AnyCancellable> = []
    private let options: [Options]
    
    init(debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options]) {
        self.debuggerItems = debuggerItems
        self.widgetView = .init(complications: complications)
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = View(frame: .null)
        
        view.addSubview(launchView)
        view.addSubview(widgetView)
        
        launchView.isHidden = true
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
                self.present(ac, animated: true, completion: nil)
            }))
        }
        
        widget: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            widgetView.addGestureRecognizer(gesture)
            gesture.moveInitialPosition(.topLeading)
        }
        
        if options.contains(.showWidgetOnLaunch) {
            widgetView.show()
        } else {
            widgetView.hide()
        }
        launchView.isHidden = false
    }
    
    private func presentMenu() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(.init(title: "Hide until next launch", style: .destructive, handler: { [weak self] _ in
            self?.launchView.isHidden = true
            self?.widgetView.hide()
        }))
        if widgetView.isHidden {
            sheet.addAction(.init(title: "Show widget", style: .default, handler: { [weak self] _ in
                self?.widgetView.show()
            }))
        } else {
            sheet.addAction(.init(title: "Hide widget", style: .destructive, handler: { [weak self] _ in
                self?.widgetView.hide()
            }))
        }
        sheet.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}
