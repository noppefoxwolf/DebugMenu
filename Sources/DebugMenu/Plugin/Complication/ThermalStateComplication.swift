//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/07/12.
//

import Combine
import Foundation

public class ThermalStateComplication: ComplicationPresentable {
    public init() {}
    public let title: String = "Thermal"
    var currentThermalState: ProcessInfo.ThermalState = .nominal

    private var cancellables: Set<AnyCancellable> = []

    public func startMonitoring() {
    }

    public func stopMonitoring() {
        cancellables = []
    }

    public func update() {
        currentThermalState = Device.current.thermalState
    }

    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            switch self?.currentThermalState {
            case .critical:
                return "critical"
            case .serious:
                return "serious"
            case .fair:
                return "fair"
            case .nominal:
                return "nominal"
            default:
                return "-"
            }
        }
    }
}
