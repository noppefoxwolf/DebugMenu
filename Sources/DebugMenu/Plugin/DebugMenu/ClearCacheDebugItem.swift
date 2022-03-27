import UIKit

public struct ClearCacheDebugItem: DebugItem {
    public init() {}

    public let debugItemTitle: String = "Clear Cache"
    public let action: DebugItemAction = .execute {
        do {
            try ClearCacheDebugItem.clearCache()
            return .success(message: "The cache completely cleared.")
        } catch {
            return .failure(message: "\(error)")
        }
    }

    static func clearCache() throws {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileManager = FileManager.default
        // Get the directory contents urls (including subfolders urls)
        let directoryContents = try FileManager.default.contentsOfDirectory(
            at: cacheURL,
            includingPropertiesForKeys: nil,
            options: []
        )
        for file in directoryContents {
            try fileManager.removeItem(at: file)
        }
    }
}
