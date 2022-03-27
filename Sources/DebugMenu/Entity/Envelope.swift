import Foundation

public struct Envelope {
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }

    public let key: String
    public let value: String
}
