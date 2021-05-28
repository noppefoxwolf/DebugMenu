//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import Foundation

public struct NetworkUsage {
    public let wifiDataSent: UInt32
    public let wifiDataReceived: UInt32
    public let wwanDataSent: UInt32
    public let wwanDataReceived: UInt32
    
    public var sent: UInt32 { wifiDataSent + wwanDataSent }
    public var received: UInt32 { wifiDataReceived + wwanDataReceived }
}
