//
//  SliderCell.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/18.
//

import UIKit

@available(iOS 14, *)
class SliderCell: UICollectionViewListCell {
    var title: String!
    var current: (() -> Double)!
    var range: ClosedRange<Double>!
    var onChange: ((Double) -> Void)!

    override func updateConfiguration(using state: UICellConfigurationState) {
        let configuration = SliderCellConfiguration(title: title, current: current, range: range, onChange: onChange)
        contentConfiguration = configuration
    }
}

@available(iOS 14, *)
struct SliderCellConfiguration: UIContentConfiguration {
    let title: String
    let current: () -> Double
    let range: ClosedRange<Double>
    let onChange: (Double) -> Void

    func makeContentView() -> UIView & UIContentView {
        SliderCellView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self { self }
}

@available(iOS 14, *)
class SliderCellView: UIView, UIContentView {
    var configuration: UIContentConfiguration
    
    init(configuration: SliderCellConfiguration) {
        self.configuration = configuration
        super.init(frame: .null)
        
        let titleLabel = UILabel(frame: .null)
        titleLabel.text = configuration.title
        let valueLabel = UILabel(frame: .null)
        
        let slider = UISlider(frame: .null, primaryAction: UIAction(handler: { (action) in
            if let slider = action.sender as? UISlider {
                valueLabel.text = String(format: "%.2f", slider.value)
                configuration.onChange(Double(slider.value))
            }
        }))
        slider.maximumValue = Float(configuration.range.upperBound)
        slider.minimumValue = Float(configuration.range.lowerBound)
        slider.setValue(Float(configuration.current()), animated: false)
        valueLabel.text = String(format: "%.2f", slider.value)
        
        let hStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        hStack.axis = .horizontal
        
        let vStack = UIStackView(arrangedSubviews: [hStack, slider])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
