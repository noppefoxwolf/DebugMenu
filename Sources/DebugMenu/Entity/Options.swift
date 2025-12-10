import Foundation
import UIKit

public enum Options: Sendable {
    case showsWidgetOnLaunch
    case showsRecentItems
    case launchIcon(LaunchIcon)

    public struct LaunchIcon: Sendable {
        public typealias Position = FloatingItemGestureRecognizer.Edge

        let image: UIImage?
        let initialPosition: Position

        public init(
            image: UIImage? = nil,
            initialPosition: Position = .bottomTrailing
        ) {
            self.image = image
            self.initialPosition = initialPosition
        }
    }

    public static var `default`: [Options] { [.showsRecentItems] }

    var isShowsWidgetOnLaunch: Bool {
        if case .showsWidgetOnLaunch = self { return true }
        return false
    }

    var isShowsRecentItems: Bool {
        if case .showsRecentItems = self { return true }
        return false
    }
}
