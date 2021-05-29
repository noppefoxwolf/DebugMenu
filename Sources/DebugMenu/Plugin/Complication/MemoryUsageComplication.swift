//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

public struct MemoryUsageComplication: ComplicationPresentable {
    public init() {}
    public let title: String = "MEM"
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public let fetcher: MetricsFetcher = .text {
        Device.current.localizedMemoryUsage
    }
}
