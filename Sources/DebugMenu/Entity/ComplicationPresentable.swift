//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

public protocol ComplicationPresentable {
    var title: String { get }
    func startMonitoring()
    func stopMonitoring()
    var fetcher: MetricsFetcher { get }
}

