import Foundation

public protocol DashboardItem {
    var title: String { get }
    func startMonitoring()
    func stopMonitoring()
    func update()
    var fetcher: MetricsFetcher { get }
}
