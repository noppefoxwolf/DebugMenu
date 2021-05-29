//
//  CustomComplication.swift
//  Shared
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import DebugMenu

public class CustomComplication: ComplicationPresentable {
    public init() {}
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public let fetcher: MetricsFetcher = .text {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    public var title: String = "Date"
}
