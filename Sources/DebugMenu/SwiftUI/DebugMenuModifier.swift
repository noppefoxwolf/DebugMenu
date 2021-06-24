//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
struct DebugMenuModifier: ViewModifier {
    internal init(debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options]) {
        self.debuggerItems = debuggerItems
        self.complications = complications
        self.options = options
    }
    
    let debuggerItems: [DebugMenuPresentable]
    let complications: [ComplicationPresentable]
    let options: [Options]
    
    func body(content: Content) -> some View {
        content.onAppear(perform: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                DebugMenu.install(windowScene: windowScene, items: debuggerItems, complications: complications, options: options)
            }
        })
    }
}

@available(iOS 14, *)
public extension View {
    @ViewBuilder
    func debugMenu(debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], options: [Options] = [], enabled: Bool = true) -> some View {
        if enabled {
            modifier(DebugMenuModifier(debuggerItems: debuggerItems, complications: complications, options: options))
        } else {
            self
        }
    }
}
