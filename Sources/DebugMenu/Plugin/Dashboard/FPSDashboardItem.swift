import Foundation
import QuartzCore

public class FPSDashboardItem: DashboardItem {
    public let title: String = "FPS"
    var displayLink: CADisplayLink?
    var lastupdated: CFTimeInterval = 0
    var updateCount: Int = 1
    var currentFPS: Int = 0

    public init() {}

    public func startMonitoring() {
        displayLink = .init(target: self, selector: #selector(updateDisplayLink))
        displayLink?.preferredFramesPerSecond = 0
        displayLink?.add(to: .main, forMode: .common)
    }

    public func stopMonitoring() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc func updateDisplayLink(_ displayLink: CADisplayLink) {
        if displayLink.timestamp - lastupdated > 1.0 {
            currentFPS = updateCount
            updateCount = 1
            lastupdated = displayLink.timestamp
        } else {
            updateCount += 1
        }
    }

    public func update() {

    }

    public var fetcher: MetricsFetcher {
        .text { [weak self] in
            guard let self = self else { return "-" }
            return "\(self.currentFPS)"
        }
    }
}
