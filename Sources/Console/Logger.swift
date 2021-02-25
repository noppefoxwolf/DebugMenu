//
//  Logger.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2021/02/25.
//

import Foundation
import Logging
import DebugMenu

extension URL {
    static func makeDebugMenuURL() -> URL {
        URL(fileURLWithPath: NSTemporaryDirectory() + "/DebugMenu/")
    }
    
    static func makeLogURL() -> URL {
        makeDebugMenuURL().appendingPathComponent(makeLogFileName())
    }
    
    static func makeLogFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return Application.current.appName + "-" + dateFormatter.string(from: Date()) + ".log"
    }
}

struct TextOutputWriterStream: TextOutputStream {
    let outputStream: OutputStream
    internal static let session = TextOutputWriterStream(url: URL.makeLogURL())
    
    init(url: URL) {
        outputStream = OutputStream(url: url, append: true)!
        outputStream.open()
    }
    
    mutating func write(_ string: String) {
        _ = string.data(using: .utf8)?.withUnsafeBytes({
            outputStream.write($0.baseAddress!.assumingMemoryBound(to: UInt8.self), maxLength: $0.count)
        })
    }
}

public struct WriteLogHandler: LogHandler {
    public static func output(label: String) -> WriteLogHandler {
        WriteLogHandler(label: label, stream: TextOutputWriterStream.session)
    }
    
    private let stream: TextOutputStream
    private let label: String
    
    public var logLevel: Logger.Level = .info
    
    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }
    
    // internal for testing only
    internal init(label: String, stream: TextOutputStream) {
        self.label = label
        self.stream = stream
        
        _ = try? FileManager.default.createDirectory(at: URL.makeDebugMenuURL(), withIntermediateDirectories: true)
    }
    
    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        
        var stream = self.stream
        stream.write("\(self.timestamp()) \(level) \(self.label) :\(prettyMetadata.map { " \($0)" } ?? "") \(message)\n")
    }
    
    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty
            ? metadata.lazy.sorted(by: { $0.key < $1.key }).map { "\($0)=\($1)" }.joined(separator: " ")
            : nil
    }
    
    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}
