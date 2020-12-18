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
        toggle.addTarget(self, action: #selector(self.onValueChangeToggle(_:)), for: .valueChanged)
        let configuration = UICellAccessory.CustomViewConfiguration(customView: toggle, placement: .trailing())
        accessories = [.customView(configuration: configuration)]
    }
    
    @objc private func onValueChangeToggle(_ toggle: UISwitch) {
        onChange(toggle.isOn)
    }
}
