import Foundation

public enum MetricsFetcher: Sendable {
    case text(_ fetcher: @Sendable @MainActor () -> String)
    case graph(_ fetcher: @Sendable @MainActor () -> [Double])
    case interval(_ fetcher: @Sendable @MainActor () -> [TimeInterval])
}
