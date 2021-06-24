//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import UIKit

@available(iOS 14, *)
class LaunchView: UIVisualEffectView {
    private let button: UIButton = .init(frame: .null)
    
    init() {
        super.init(effect: UIBlurEffect(style: .systemMaterialDark))
        frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        let image = UIImage(systemName: "ant.fill")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 22
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var menu: UIMenu? {
        get { button.menu }
        set { button.menu = newValue }
    }
    
    func addAction(_ action: UIAction) {
        button.addAction(action, for: .touchUpInside)
    }
}
