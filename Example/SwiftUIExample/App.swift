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

    @ObservedObject private var store = Store()

    private final class Store: ObservableObject {
        private(set) var sliderValue: Double = 0.1

        func updateSliderValue(_ value: Double) { sliderValue = value }
    }

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
                            SliderDebugItem(title: "Attack Rate", current: { store.sliderValue }, valueLabel: { "\(String(format: "%.2f", store.sliderValue))%" }, range: 0.0...100.0, onChange: store.updateSliderValue),
                KeyValueDebugItem(title: "UserDefaults", fetcher: { completions in
                    let envelops = UserDefaults.standard.dictionaryRepresentation().map({ Envelope(key: $0.key, value: "\($0.value)") })
                    completions(envelops)
                }),
                GroupDebugItem(title: "Info", items: [
                    AppInfoDebugItem(),
                    DeviceInfoDebugItem(),
                ]),
            ], dashboardItems: [
                CPUUsageDashboardItem(),
                CPUGraphDashboardItem(),
                GPUMemoryUsageDashboardItem(),
                MemoryUsageDashboardItem(),
                NetworkUsageDashboardItem(),
                FPSDashboardItem(),
                ThermalStateDashboardItem(),
                CustomDashboardItem(),
                IntervalDashboardItem(title: "Reduce time", name: "dev.noppe.calc")
            ], options: [.showsWidgetOnLaunch])
        }
    }
}
