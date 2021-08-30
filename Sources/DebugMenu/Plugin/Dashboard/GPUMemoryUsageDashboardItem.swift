//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

public class GPUMemoryUsageDashboardItem:  DashboardItem {
    public init() {}
    public let title: String = "GPU MEM"
    private var text: String = ""
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public func update() {
        text = Device.current.localizedGPUMemory
    }
    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            self?.text ?? ""
        }
    }
}
