//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import UIKit

class DebugButtonViewController: UIViewController {
    internal init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let floatingView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    private let floatingButton: FloatingButton = FloatingButton(frame: .null)
    let debuggerItems: [DebugMenuPresentable]
    
    override func loadView() {
        view = floatingView
        
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "ant.fill")
        floatingButton.setImage(image, for: .normal)
        floatingButton.tintColor = UIColor.white
        floatingView.contentView.addSubview(floatingButton)
        
        NSLayoutConstraint.activate([
            floatingButton.topAnchor.constraint(equalTo: floatingView.topAnchor),
            floatingButton.leftAnchor.constraint(equalTo: floatingView.leftAnchor),
            floatingButton.rightAnchor.constraint(equalTo: floatingView.rightAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: floatingView.bottomAnchor),
        ])
        
        floatingView.layer.cornerCurve = .continuous
        floatingView.layer.cornerRadius = 22
        floatingView.layer.masksToBounds = true
        
        floatingButton.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
    }
    
    @objc private func onTap(_ sender: UIButton) {
        let vc = InAppDebuggerViewController(debuggerItems: debuggerItems)
        let nc = UINavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        let ac = CustomActivityViewController(controller: nc)
        ac.popoverPresentationController?.sourceView = floatingButton
        self.present(ac, animated: true, completion: nil)
    }
}
