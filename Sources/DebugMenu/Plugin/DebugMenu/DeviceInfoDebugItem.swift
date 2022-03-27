import Foundation

public struct DeviceInfoDebugItem: DebugItem {
    public init() {}
    public var debugItemTitle: String = "Device Info"
    public var action: DebugItemAction = .didSelect { parent in
        let vc = await EnvelopePreviewTableViewController {
            [
                "Name": Device.current.name,
                "Battery level": Device.current.localizedBatteryLevel,
                "Battery state": Device.current.localizedBatteryState,
                "Model": Device.current.localizedModel,
                "System name": Device.current.systemName,
                "System version": Device.current.systemVersion,
                "Jailbreak?": Device.current.isJailbreaked ? "YES" : "NO",
                "System uptime": Device.current.localizedSystemUptime,
                "Uptime": Device.current.localizedUptime,
                "LowPower mode?": Device.current.isLowPowerModeEnabled ? "YES" : "NO",
                "Processor": Device.current.processor,
                "Physical Memory": Device.current.localizedPhysicalMemory,
                "Disk usage": Device.current.localizedDiskUsage,
            ]
            .map({ Envelope(key: $0.key, value: $0.value) }).sorted(by: { $0.key < $1.key })
        }
        await parent.navigationController?.pushViewController(vc, animated: true)
        return .success()
    }

}
