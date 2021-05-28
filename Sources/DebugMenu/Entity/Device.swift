//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import UIKit

public class Device {
    public static let current: Device = .init()
    
    public var localizedModel: String {
        UIDevice.current.localizedModel
    }
    
    public var model: String {
        UIDevice.current.model
    }
    
    public var name: String {
        UIDevice.current.name
    }
    
    public var systemName: String {
        UIDevice.current.systemName
    }
    
    public var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    public var localizedBatteryLevel: String {
        "\(batteryLevel * 100.00) %"
    }
    
    public var batteryLevel: Float {
        UIDevice.current.batteryLevel
    }
    
    public var batteryState: UIDevice.BatteryState {
        UIDevice.current.batteryState
    }
    
    public var localizedBatteryState: String {
        "\(batteryState)"
    }
    
    public var isJailbreaked: Bool {
        FileManager.default.fileExists(atPath: "/private/var/lib/apt")
    }
    
    public var thermalState: ProcessInfo.ThermalState {
        ProcessInfo.processInfo.thermalState
    }
    
    public var localizedThermalState: String {
        "\(thermalState)"
    }
    
    public var processorCount: Int {
        ProcessInfo.processInfo.processorCount
    }
    
    public var activeProcessorCount: Int {
        ProcessInfo.processInfo.activeProcessorCount
    }
    
    public var processor: String {
        "\(activeProcessorCount) / \(processorCount)"
    }
    
    public var isLowPowerModeEnabled: Bool {
        ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    public var physicalMemory: UInt64 {
        ProcessInfo.processInfo.physicalMemory
    }
    
    public var localizedPhysicalMemory: String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .memory
        return formatter.string(fromByteCount: Int64(physicalMemory))
    }
    
    public var systemUptime: TimeInterval {
        ProcessInfo.processInfo.systemUptime
    }
    
    public func uptime() -> time_t {
        var boottime = timeval()
        var mib: [Int32] = [CTL_KERN, KERN_BOOTTIME]
        var size = MemoryLayout<timeval>.stride

        var now = time_t()
        var uptime: time_t = -1

        time(&now)
        if (sysctl(&mib, 2, &boottime, &size, nil, 0) != -1 && boottime.tv_sec != 0) {
            uptime = now - boottime.tv_sec
        }
        return uptime
    }
    
    public var localizedSystemUptime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: systemUptime) ?? "-"
    }
    
    public var localizedUptime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .brief
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: TimeInterval(uptime())) ?? "-"
    }
}
