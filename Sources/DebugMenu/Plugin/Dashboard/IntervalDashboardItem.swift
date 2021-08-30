//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import Combine
import Foundation

public class IntervalDashboardItem:  DashboardItem {
    public init(title: String, name: String) {
        self.title = title
        self.name = Notification.Name(name)
    }

    public let title: String
    private let name: Notification.Name
    var intervals: [TimeInterval] = []
    private var cancellables: Set<AnyCancellable> = []

    public func startMonitoring() {
        NotificationCenter.default.publisher(for: name)
            .sink { notification in
                if let interval = notification.userInfo?[IntervalTracker.intervalKey]
                    as? TimeInterval
                {
                    self.intervals.append(interval)
                }
            }
            .store(in: &cancellables)
    }

    public func stopMonitoring() {
        cancellables = []
    }

    public func update() {

    }

    public var fetcher: MetricsFetcher {
        .interval { [weak self] in
            guard let self = self else { return [] }
            return self.intervals
        }
    }
}

public class IntervalTracker {
    public enum SignpostType {
        case begin
        case end
    }
    static let intervalKey: String = "dev.noppe.intervalTracker.interval"

    public init(name: String) {
        notificationName = .init(name)
    }

    let notificationName: Notification.Name
    var beginDate: Date?

    public func track(_ type: SignpostType) {
        switch type {
        case .begin:
            beginDate = Date()
        case .end:
            guard let beginDate = beginDate else { return }
            let interval = Date().timeIntervalSince(beginDate)
            NotificationCenter.default.post(
                Notification(
                    name: notificationName,
                    object: nil,
                    userInfo: [IntervalTracker.intervalKey: interval]
                )
            )
        }
    }
}
