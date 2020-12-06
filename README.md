# DebugMenu

## Usage

``` 
#if DEBUG
DebugMenu.install(windowScene: windowScene, items: [
    ViewControllerDebugItem<ColorViewController>(builder: { $0.init(color: .blue) }),
    ClearCacheDebugItem(),
    UserDefaultsResetDebugItem(),
    CustomDebugItem()
])
#endif
```

## Custom debug item

```
struct CustomDebugItem: DebugMenuPresentable {
    let debuggerItemTitle: String = "Custom item"
    func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        completionHandler(.success(message: "OK"))
    }
}
```

## License

MIT