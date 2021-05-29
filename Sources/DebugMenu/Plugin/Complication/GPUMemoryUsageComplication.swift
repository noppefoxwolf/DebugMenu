//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

public struct GPUMemoryUsageComplication: ComplicationPresentable {
    public init() {}
    public let title: String = "GPU MEM"
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public let fetcher: MetricsFetcher = .text {
        Device.current.localizedGPUMemory
    }
}




