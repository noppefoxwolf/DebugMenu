//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import Foundation
@available(iOS 14, *)
public struct DeviceInfoDebugItem: DebugMenuPresentable {
    public init() {}
    public var debuggerItemTitle: String = "Device Info"
    public var action: DebugMenuAction = .didSelect { parent, completions in
        let vc = EnvelopePreviewTableViewController { completions in
            DispatchQueue.global().async {
                let envelops = [
                    "Name" : Device.current.name,
                    "Battery level" : Device.current.localizedBatteryLevel,
                    "Battery state" : Device.current.localizedBatteryState,
                    "Model" : Device.current.localizedModel,
                    "System name" : Device.current.systemName,
                    "System version" : Device.current.systemVersion,
                    "Jailbreak?" : Device.current.isJailbreaked ? "YES" : "NO",
                    "System uptime" : Device.current.localizedSystemUptime,
                    "Uptime" : Device.current.localizedUptime,
                    "LowPower mode?" : Device.current.isLowPowerModeEnabled ? "YES" : "NO",
                    "Processor" : Device.current.processor,
                    "Physical Memory" : Device.current.localizedPhysicalMemory,
                    "Disk usage" : Device.current.localizedDiskUsage,
                ].map({ Envelope(key: $0.key, value: $0.value) })
                DispatchQueue.main.async {
                    completions(envelops)
                }
            }
            
        }
        parent.navigationController?.pushViewController(vc, animated: true)
        completions(.success())
    }
    

}
