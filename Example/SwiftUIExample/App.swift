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
            Button(action: {}, label: {
                Text("Hello, world!")
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
                AppInfoDebugItem(),
                DeviceInfoDebugItem(),
            ], complications: [
                CPUUsageComplication(),
                GPUMemoryUsageComplication(),
                MemoryUsageComplication(),
                NetworkUsageComplication(),
                FPSComplication(),
                CustomComplication(),
            ])
        }
    }
}
