# DebugMenu

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
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        completionHandler(.success(message: "OK"))
    }
}
```

## License

MIT
