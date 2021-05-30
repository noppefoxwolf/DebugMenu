//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import Foundation

public class CPUGraphComplication: ComplicationPresentable {
    public init() {}
    public let title: String = "CPU"
    private var data: [Double] = []
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public func update() {
        let metrics = Device.current.cpuUsage()
        data.append(Double(metrics * 100.0))
    }
    public var fetcher: MetricsFetcher {
        .graph { [weak self] in
            self?.data ?? []
        }
    }
}
