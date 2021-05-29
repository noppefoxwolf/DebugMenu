//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation
import Combine

public class NetworkUsageComplication: ComplicationPresentable {
    public init() {}
    public let title: String = "Network"
    var lastNetworkUsage: NetworkUsage? = nil
    var sendPerSec: UInt32 = 0
    var receivedPerSec: UInt32 = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    public func startMonitoring() {
        Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink { [weak self] _ in
            self?.update()
        }.store(in: &cancellables)
    }
    
    public func stopMonitoring() {
        cancellables = []
    }
    
    private func update() {
        let networkUsage = Device.current.networkUsage()
        if let lastUsage = lastNetworkUsage, let newUsage = networkUsage {
            sendPerSec = newUsage.sent - lastUsage.sent
            receivedPerSec = newUsage.received - lastUsage.received
        }
        lastNetworkUsage = networkUsage
    }
    
    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            guard let self = self else { return "-" }
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            formatter.allowsNonnumericFormatting = false
            return "↑\(formatter.string(fromByteCount: Int64(self.sendPerSec)))/s\n↓\(formatter.string(fromByteCount: Int64(self.receivedPerSec)))/s"
        }
    }
}
