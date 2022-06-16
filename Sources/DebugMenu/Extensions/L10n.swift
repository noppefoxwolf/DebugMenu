import Foundation

extension String {
    static var showWidget: String { makeLocalizaedString("Show widget") }
    static var hideWidget: String { makeLocalizaedString("Hide widget") }
    static var hideUntilNextLaunch: String { makeLocalizaedString("Hide until next launch") }
    static var cancel: String { makeLocalizaedString("Cancel") }
    
    private static func makeLocalizaedString(_ key: String) -> String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}
