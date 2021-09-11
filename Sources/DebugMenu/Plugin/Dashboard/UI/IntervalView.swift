//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import UIKit

class IntervalView: UIStackView {
    private var latestInterval: TimeInterval?
    private var minInterval: TimeInterval?
    private var maxInterval: TimeInterval?

    private var latestIntervalLabel: UILabel = .init()
    private var minIntervalLabel: UILabel = .init()
    private var maxIntervalLabel: UILabel = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fillEqually
        axis = .vertical
        spacing = 0
        backgroundColor = .black
        addArrangedSubview(latestIntervalLabel)
        latestIntervalLabel.font = UIFont.systemFont(ofSize: 10)
        latestIntervalLabel.textColor = .white
        addArrangedSubview(minIntervalLabel)
        minIntervalLabel.font = UIFont.systemFont(ofSize: 10)
        minIntervalLabel.textColor = .systemGreen
        addArrangedSubview(maxIntervalLabel)
        maxIntervalLabel.font = UIFont.systemFont(ofSize: 10)
        maxIntervalLabel.textColor = .systemRed
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(duration: TimeInterval) {
        latestInterval = duration
        minInterval = minInterval.map({ min(duration, $0) }) ?? duration
        maxInterval = maxInterval.map({ max(duration, $0) }) ?? duration
        updateLabels()
    }

    func reload(durations: [TimeInterval]) {
        latestInterval = durations.last
        minInterval = durations.min()
        maxInterval = durations.max()
        updateLabels()
    }

    private func updateLabels() {
        latestIntervalLabel.text = latestInterval.map({ String(format: "%.3f", $0) })
        minIntervalLabel.text = minInterval.map({ String(format: "%.3f", $0) })
        maxIntervalLabel.text = maxInterval.map({ String(format: "%.3f", $0) })
    }
}
