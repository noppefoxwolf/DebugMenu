//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation
import Metal

class GPU {
    static var current: GPU = .init()
    let device: MTLDevice
    
    init() {
        device = MTLCreateSystemDefaultDevice()!
    }
    
    var currentAllocatedSize: Int {
        device.currentAllocatedSize
    }
}
