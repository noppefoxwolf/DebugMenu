//
//  Application.swift
//  App
//
//  Created by Tomoya Hirano on 2020/03/01.
//

import UIKit

public class Application {
    public static var current: Application = .init()
    
    public var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    public var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    public var build: String {
        Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as! String
    }
    
    public var buildNumber: Int {
        Int(build) ?? 0
    }
    
    public var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
