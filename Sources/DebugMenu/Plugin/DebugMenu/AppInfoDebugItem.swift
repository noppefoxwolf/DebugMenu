//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/28.
//

import Foundation

public struct AppInfoDebugItem: DebugMenuPresentable {
    public init() {}
    public var debuggerItemTitle: String = "App Info"
    public var action: DebugMenuAction = .didSelect { parent, completions in
        let vc = EnvelopePreviewTableViewController { completions in
            DispatchQueue.global()
                .async {
                    let envelops = [
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
                    DispatchQueue.main.async {
                        completions(envelops)
                    }
                }

        }
        parent.navigationController?.pushViewController(vc, animated: true)
        completions(.success())
    }

}
