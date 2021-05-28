//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/29.
//

import Foundation

class CPU {
    static func usage() -> Float {
        let ids = threadIDs()
        var totalUsage: Float = 0
        for id in ids {
            let usage = threadUsage(id: id)
            totalUsage += usage
        }
        return totalUsage
    }
    
    static func threadIDs() -> [UInt32] {
        var threadList = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
        var threadCount = UInt32(MemoryLayout<mach_task_basic_info_data_t>.size / MemoryLayout<natural_t>.size)
        let result = withUnsafeMutablePointer(to: &threadList) {
            $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadCount)
            }
        }
        if result != KERN_SUCCESS { return [] }
        var ids: [UInt32] = []
        for index in (0..<Int(threadCount)) {
            ids.append(threadList[index])
        }
        return ids
    }
    
    static func threadUsage(id: UInt32) -> Float {
        var threadInfo = thread_basic_info()
        var threadInfoCount = UInt32(THREAD_INFO_MAX)
        let result = withUnsafeMutablePointer(to: &threadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                thread_info(id, UInt32(THREAD_BASIC_INFO), $0, &threadInfoCount)
            }
        }
        // スレッド情報が取れない = 該当スレッドのCPU使用率を0とみなす(基本nilが返ることはない)
        if result != KERN_SUCCESS { return 0 }
        let isIdle = threadInfo.flags == TH_FLAGS_IDLE
        // CPU使用率がスケール調整済みのため`TH_USAGE_SCALE`で除算し戻す
        return !isIdle ? Float(threadInfo.cpu_usage) / Float(TH_USAGE_SCALE) : 0
    }
}
