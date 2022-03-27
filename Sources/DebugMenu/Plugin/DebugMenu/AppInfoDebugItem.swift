import Foundation

public struct AppInfoDebugItem: DebugItem {
    public init() {}
    public var debugItemTitle: String = "App Info"
    public var action: DebugItemAction = .didSelect { parent in
        let vc = await EnvelopePreviewTableViewController {
            [
                "App Name": Application.current.appName,
                "Version": Application.current.version,
                "Build": Application.current.build,
                "Bundle ID": Application.current.bundleIdentifier,
                "App Size": Application.current.size,
                "Locale": Application.current.locale,
                "Localization": Application.current.preferredLocalizations,
                "TestFlight?": Application.current.isTestFlight ? "YES" : "NO",
            ]
            .map({ Envelope.init(key: $0.key, value: $0.value) })
            .sorted(by: { $0.key < $1.key })
        }
        await parent.navigationController?.pushViewController(vc, animated: true)
        return .success()
    }

}
