//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

public enum MetricsFetcher {
    case text(_ fetcher: () -> String)
    case progress(_ fetcher: () -> Double)
}
