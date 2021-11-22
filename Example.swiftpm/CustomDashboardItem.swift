import DebugMenu
import Foundation

public class CustomDashboardItem:  DashboardItem {
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
