# DebugMenu

![](https://github.com/noppefoxwolf/DebugMenu/blob/main/.github/example.gif)

## Installation

### Swift Package Manager

Select File > Swift Packages > Add Package Dependency. Enter https://github.com/noppefoxwolf/DebugMenu in the "Choose Package Repository" dialog.

### Cocoapods

```ruby
pod 'DebugMenu', :git => 'https://github.com/noppefoxwolf/DebugMenu.git'

```

## Usage

### UIKit based

```swift
#if DEBUG
DebugMenu.install(windowScene: windowScene, items: [
    ViewControllerDebugItem<ColorViewController>(),
    ClearCacheDebugItem(),
    UserDefaultsResetDebugItem(),
    CustomDebugItem()
], dashboardItems: [
    CPUUsageDashboardItem()
])
#endif
```

### SwiftUI based

```swift
@main
struct App: SwiftUI.App {    
    var body: some Scene {
        WindowGroup {
            Root.View(
                store: .init(
                    initialState: .init(),
                    reducer: Root.reducer,
                    environment: .debug
                )
            ).debugMenu(debuggerItems: [
                ViewControllerDebugItem<ColorViewController>(),
                ClearCacheDebugItem(),
                UserDefaultsResetDebugItem(),
                CustomDebugItem()
            ], dashboardItems: [
                CPUUsageDashboardItem()
            ])
        }
    }
}
```

## Custom debug item

```swift
struct CustomDebugItem: DebugItem {
    let debugItemTitle: String = "Custom item"
    let action: DebugItemAction = .toggle { UserDefaults.standard.bool(forKey: "key") } action: { (isOn, completions) in
        let userDefaults = UserDefaults.standard
        userDefaults.set(isOn, forKey: "key")
        if userDefaults.synchronize() {
            completions(.success(message: "Switch to \(isOn)"))
        } else {
            completions(.failure(message: "Failed to save"))
        }
    }
}
```

## Custom dashboard item

```swift
public class CustomDashboardItem: DashboardItem {
    public init() {}
    public func startMonitoring() {}
    public func stopMonitoring() {}
    public let fetcher: MetricsFetcher = .text {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: Date())
    }
    public var title: String = "Date"
}
```

# Plugins

- [DebugMenuConsolePlugin](https://github.com/noppefoxwolf/DebugMenuConsolePlugin)

# How to use

## Open DebugMenu

Tap floating bug button.

## Show Dashboard

Longpress floating bug button, and tap `Show widget`.

# License

License
DebugMenu is released under the MIT license. See LICENSE for details.
