//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import UIKit

class LaunchView: UIVisualEffectView {
    private let button: UIButton = .init(frame: .null)

    init(image: UIImage? = nil) {
        super.init(effect: UIBlurEffect(style: .systemMaterialDark))
        frame = CGRect(x: 0, y: 0, width: 44, height: 44)

        button.setImage(image ?? .init(systemName: "ant.fill"), for: .normal)
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
