//
//  CustomComplication.swift
//  Shared
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import DebugMenu

public class CustomComplication: ComplicationPresentable {
    public init() {}
    public var title: String = "Date"
    private var text: String = ""
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public func update() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        text = formatter.string(from: Date())
    }
    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            self?.text ?? ""
        }
    }
}
