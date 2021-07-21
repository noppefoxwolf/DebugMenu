//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import Foundation

public struct NetworkUsage {
    public let wifiDataSent: UInt64
    public let wifiDataReceived: UInt64
    public let wwanDataSent: UInt64
    public let wwanDataReceived: UInt64

    public var sent: UInt64 { wifiDataSent + wwanDataSent }
    public var received: UInt64 { wifiDataReceived + wwanDataReceived }
}
