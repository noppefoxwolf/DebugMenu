import Foundation

public class CPUUsageDashboardItem: DashboardItem {
    public init() {}
    public let title: String = "CPU"
    private var text: String = ""
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public func update() {
        text = Device.current.localizedCPUUsage
    }
    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            self?.text ?? ""
        }
    }
}
