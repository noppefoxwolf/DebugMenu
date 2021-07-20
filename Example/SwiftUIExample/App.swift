//
//  SwiftUIExampleApp.swift
//  SwiftUIExample
//
//  Created by Tomoya Hirano on 2021/05/26.
//

import SwiftUI
import Logging
import DebugMenu
import Shared
import DebugMenuConsolePlugin

@main
struct App: SwiftUI.App {
    init() {
        LoggingSystem.bootstrap({
            MultiplexLogHandler([
                StreamLogHandler.standardOutput(label: $0),
                WriteLogHandler.output(label: $0)
            ])
        })
        Logger(label: "dev.noppe.debugMenu.logger").info("Launch")
    }
    
    var body: some Scene {
        WindowGroup {
            Button(action: {
                let tracker = IntervalTracker(name: "dev.noppe.calc")
                tracker.track(.begin)
                let _ = (0..<10000000).reduce(0, +)
                tracker.track(.end)
            }, label: {
                Text("calculate")
            }).debugMenu(debuggerItems: [
                ConsoleDebugItem(),
                ViewControllerDebugItem<ColorViewController>(builder: { $0.init(color: .blue) }),
                ClearCacheDebugItem(),
                UserDefaultsResetDebugItem(),
                CustomDebugItem(),
                RangeDebugItem(title: "Attack Rate", current: { 0.1 }, range: 0.0...100.0, onChange: { value in print(value) }),
                KeyValueDebugItem(title: "UserDefaults", fetcher: { completions in
                    let envelops = UserDefaults.standard.dictionaryRepresentation().map({ Envelope(key: $0.key, value: "\($0.value)") })
                    completions(envelops)
                }),
                GroupDebugItem(title: "Info", items: [
                    AppInfoDebugItem(),
                    DeviceInfoDebugItem(),
                ]),
            ], complications: [
                CPUUsageComplication(),
                CPUGraphComplication(),
                GPUMemoryUsageComplication(),
                MemoryUsageComplication(),
                NetworkUsageComplication(),
                FPSComplication(),
                ThermalStateComplication(),
                CustomComplication(),
                IntervalComplication(title: "Reduce time", name: "dev.noppe.calc")
            ], options: [.showsWidgetOnLaunch])
        }
    }
}
