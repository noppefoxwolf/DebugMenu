# DebugMenu

![](https://github.com/noppefoxwolf/DebugMenu/blob/main/.github/example.gif)

## Installation

### Swift Package Manager

Select File > Swift Packages > Add Package Dependency. 
Enter https://github.com/noppefoxwolf/DebugMenu in the "Choose Package Repository" dialog.

```swift
.package(url: "https://github.com/noppefoxwolf/DebugMenu", from: "2.0.4")
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
        let updater = Updater()
        do {
            await updater.update()
            return .success(message: "Updated")
        } catch {
            return .failure(message: "Faild to update")
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

# Exclude DebugMenu in production

Read following article.
[Linking a Swift package only in debug builds](https://augmentedcode.io/2022/05/02/linking-a-swift-package-only-in-debug-builds/)

# How to use

## Open DebugMenu

Tap floating bug button.

## Show Dashboard

Longpress floating bug button, and tap `Show widget`.

# License

License
DebugMenu is released under the MIT license. See LICENSE for details.
