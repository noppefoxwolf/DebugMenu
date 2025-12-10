import Foundation

@MainActor
public protocol DashboardItem: Sendable {
    var title: String { get }
    func startMonitoring()
    func stopMonitoring()
    func update()
    var fetcher: MetricsFetcher { get }
}
