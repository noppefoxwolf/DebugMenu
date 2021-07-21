//
//  ToogleCell.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/19.
//

import UIKit

class ToggleCell: UICollectionViewListCell {
    var current: (() -> Bool)!
    var onChange: ((Bool) -> Void)!

    override func updateConfiguration(using state: UICellConfigurationState) {
        let toggle = UISwitch()
        toggle.isOn = current()
        toggle.addAction(
            .init(handler: { [weak self] action in
                self?.onChange(toggle.isOn)
            }),
            for: .valueChanged
        )
        let configuration = UICellAccessory.CustomViewConfiguration(
            customView: toggle,
            placement: .trailing()
        )
        accessories = [.customView(configuration: configuration)]
    }
}
