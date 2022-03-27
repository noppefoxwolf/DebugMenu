import Foundation

public class MemoryUsageDashboardItem: DashboardItem {
    public init() {}
    public let title: String = "MEM"
    private var text: String = ""
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public func update() {
        text = Device.current.localizedMemoryUsage
    }
    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            self?.text ?? ""
        }
    }
}
