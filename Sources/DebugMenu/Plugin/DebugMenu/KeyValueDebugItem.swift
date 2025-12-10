import Foundation

public struct KeyValueDebugItem: DebugItem {
    public init(
        title: String,
        fetcher: @escaping () async -> [Envelope]
    ) {
        self.title = title
        self.action = .didSelect(operation: { parent in
            let vc = EnvelopePreviewTableViewController(fetcher: fetcher)
            parent.navigationController?.pushViewController(vc, animated: true)
            return .success()
        })
    }

    let title: String
    public var debugItemTitle: String { title }
    public let action: DebugItemAction
}
