//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import UIKit

public enum MetricsFetcher {
    case text(_ fetcher: () -> String)
    case graph(_ fetcher: () -> [Double])
    case interval(_ fetcher: () -> [TimeInterval])
}
