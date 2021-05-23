//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/23.
//

import Foundation

public struct Envelope {
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    public let key: String
    public let value: String
}
