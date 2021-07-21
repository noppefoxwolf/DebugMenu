//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/30.
//

import Foundation

public enum Options {
    case showsWidgetOnLaunch
    case showsRecentItems

    public static var `default`: [Options] = [.showsRecentItems]
}
