//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Combine
import Foundation

public class NetworkUsageDashboardItem: DashboardItem {
    public init() {}
    public let title: String = "Network"
    var lastNetworkUsage: NetworkUsage? = nil
    var sendPerSec: UInt64 = 0
    var receivedPerSec: UInt64 = 0

    private var cancellables: Set<AnyCancellable> = []

    public func startMonitoring() {
        Timer.publish(every: 1, on: .main, in: .default).autoconnect()
            .sink { [weak self] _ in
                self?.updateNetworkUsage()
            }
            .store(in: &cancellables)
    }

    public func stopMonitoring() {
        cancellables = []
    }

    private func updateNetworkUsage() {
        let networkUsage = Device.current.networkUsage()
        if let lastUsage = lastNetworkUsage, let newUsage = networkUsage {
            let sendPerSec = newUsage.sent.subtractingReportingOverflow(lastUsage.sent)
            self.sendPerSec = sendPerSec.partialValue
            let receivedPerSec = newUsage.received.subtractingReportingOverflow(lastUsage.received)
            self.receivedPerSec = receivedPerSec.partialValue
        }
        lastNetworkUsage = networkUsage
    }

    public func update() {

    }

    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            guard let self = self else { return "-" }
            let formatter = ByteCountFormatter()
            formatter.countStyle = .file
            formatter.allowsNonnumericFormatting = false
            return
                "↑\(formatter.string(fromByteCount: Int64(self.sendPerSec)))/s\n↓\(formatter.string(fromByteCount: Int64(self.receivedPerSec)))/s"
        }
    }
}
