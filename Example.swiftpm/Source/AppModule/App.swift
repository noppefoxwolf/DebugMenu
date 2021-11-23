import SwiftUI
import DebugMenu

@main
struct App: SwiftUI.App {
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
                ViewControllerDebugItem<ColorViewController>(builder: { $0.init(color: .blue) }),
                ClearCacheDebugItem(),
                UserDefaultsResetDebugItem(),
                CustomDebugItem(),
                SliderDebugItem(title: "Attack Rate", current: { 0.1 }, range: 0.0...100.0, onChange: { value in print(value) }),
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
