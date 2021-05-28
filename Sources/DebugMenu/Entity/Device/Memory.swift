//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

class Memory {
    static func usage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = UInt32(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let result = withUnsafeMutablePointer(to: &info) {
            task_info(
                mach_task_self_,
                task_flavor_t(MACH_TASK_BASIC_INFO),
                $0.withMemoryRebound(to: Int32.self, capacity: 1) { UnsafeMutablePointer<Int32>($0) },
                &count
            )
        }
        return result == KERN_SUCCESS ? info.resident_size : 0
    }
}
