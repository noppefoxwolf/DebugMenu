//
//  ClearCacheDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/17.
//

import UIKit

public struct ClearCacheDebugItem: DebugMenuPresentable {
    public init() {}

    public let debuggerItemTitle: String = "Clear Cache"
    public let action: DebugMenuAction = .execute { (completions) in
        do {
            try ClearCacheDebugItem.clearCache()
            completions(.success(message: "The cache completely cleared."))
        } catch {
            completions(.failure(message: "\(error)"))
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
