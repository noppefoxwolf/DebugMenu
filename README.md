# DebugMenu

## Installation

Select File > Swift Packages > Add Package Dependency. Enter https://github.com/noppefoxwolf/DebugMenu in the "Choose Package Repository" dialog.

## Usage

```swift
#if DEBUG
DebugMenu.install(windowScene: windowScene, items: [
    ViewControllerDebugItem<ColorViewController>(),
    ClearCacheDebugItem(),
    UserDefaultsResetDebugItem(),
    CustomDebugItem()
])
#endif
```

## Custom debug item

```swift
struct CustomDebugItem: DebugMenuPresentable {
    let debuggerItemTitle: String = "Custom item"
    let action: DebugMenuAction = .toggle { UserDefaults.standard.bool(forKey: "key") } action: { (isOn, completions) in
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

## License

License
DebugMenu is released under the MIT license. See LICENSE for details.