//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/23.
//

import Foundation

public struct KeyValueDebugItem: DebugItem {
    public init(
        title: String,
        fetcher: @escaping (_ completions: @escaping ([Envelope]) -> Void) -> Void
    ) {
        self.title = title
        self.action = .didSelect(action: { parent, result in
            let vc = EnvelopePreviewTableViewController(fetcher: fetcher)
            parent.navigationController?.pushViewController(vc, animated: true)
            result(.success())
        })
    }

    let title: String
    public var debuggerItemTitle: String { title }
    public let action: DebugItemAction
}
