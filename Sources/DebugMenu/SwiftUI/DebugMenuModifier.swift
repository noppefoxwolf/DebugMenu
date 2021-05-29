//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import Foundation
import SwiftUI

struct DebugMenuModifier: ViewModifier {
    internal init(debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable]) {
        self.debuggerItems = debuggerItems
        self.complications = complications
    }
    
    let debuggerItems: [DebugMenuPresentable]
    let complications: [ComplicationPresentable]
    
    func body(content: Content) -> some View {
        content.onAppear(perform: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                DebugMenu.install(windowScene: windowScene, items: debuggerItems, complications: complications)
            }
        })
    }
}

public extension View {
    @ViewBuilder
    func debugMenu(debuggerItems: [DebugMenuPresentable], complications: [ComplicationPresentable], enabled: Bool = true) -> some View {
        if enabled {
            modifier(DebugMenuModifier(debuggerItems: debuggerItems, complications: complications))
        } else {
            self
        }
    }
}
