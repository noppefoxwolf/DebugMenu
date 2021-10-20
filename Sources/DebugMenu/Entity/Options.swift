//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import Foundation
import UIKit

public enum Options {
    case showsWidgetOnLaunch
    case showsRecentItems
    case launchIcon(LaunchIcon)

    public struct LaunchIcon {
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

    public static var `default`: [Options] = [.showsRecentItems]

    var isShowsWidgetOnLaunch: Bool {
        if case .showsWidgetOnLaunch = self { return true }
        return false
    }

    var isShowsRecentItems: Bool {
        if case .showsRecentItems = self { return true }
        return false
    }
}
