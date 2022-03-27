import Foundation

struct AnyDebugItem: Hashable, Identifiable, DebugItem {
    let id: String
    let debugItemTitle: String
    let action: DebugItemAction

    init(_ item: DebugItem) {
        id = UUID().uuidString
        debugItemTitle = item.debugItemTitle
        action = item.action
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AnyDebugItem, rhs: AnyDebugItem) -> Bool {
        lhs.id == rhs.id
    }
}
