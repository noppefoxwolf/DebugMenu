//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import UIKit

class WidgetView: UIVisualEffectView {
    private let stackView = UIStackView()
    private let button: FloatingButton = FloatingButton(frame: .null)
    let fpsLabel = FPSLabel()
    
    init() {
        super.init(effect: UIBlurEffect(style: .systemMaterialDark))
        frame = .init(origin: .zero, size: .init(width: 200, height: 100))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        stackView.isUserInteractionEnabled = false
        stackView.layoutMargins = .init(top: 6, left: 6, bottom: 6, right: 6)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        stackView.addArrangedSubview(fpsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        fpsLabel.start()
    }
    
    func stop() {
        fpsLabel.stop()
    }
}

class FPSLabel: UILabel {
    
    var displayLink: CADisplayLink?
    
    var lastupdated: CFTimeInterval = 0
    var updateCount: Int = 1
    
    var lastNetworkUsage: NetworkUsage? = nil
    
    init() {
        super.init(frame: .null)
        textColor = .white
        font = UIFont.preferredFont(forTextStyle: .caption1)
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        displayLink = .init(target: self, selector: #selector(update))
        displayLink?.preferredFramesPerSecond = 0
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stop() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        if displayLink.timestamp - lastupdated > 1.0 {
            
            var reports = """
            FPS: \(updateCount)
            CPU: \(Device.current.localizedCPUUsage)
            MEM: \(Device.current.localizedMemoryUsage)
            GPM: \(Device.current.localizedGPUMemory)
            """
            
            let networkUsage = Device.current.networkUsage()
            if let lastUsage = lastNetworkUsage, let newUsage = networkUsage {
                let sendPerSec = newUsage.sent - lastUsage.sent
                let receivedPerSec = newUsage.received - lastUsage.received
                let formatter = ByteCountFormatter()
                formatter.countStyle = .binary
                let report = "NET:↑\(formatter.string(fromByteCount: Int64(sendPerSec)))/s,↓\(formatter.string(fromByteCount: Int64(receivedPerSec)))/s"
                reports.append("\n")
                reports.append(report)
            }
            text = reports
            updateCount = 1
            lastupdated = displayLink.timestamp
            lastNetworkUsage = networkUsage
        } else {
            updateCount += 1
        }
    }
}

