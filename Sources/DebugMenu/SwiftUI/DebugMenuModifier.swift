//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import Foundation
import SwiftUI

struct DebugMenuModifier: ViewModifier {
    internal init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
    }
    
    let debuggerItems: [DebugMenuPresentable]
    
    func body(content: Content) -> some View {
        content.onAppear(perform: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                DebugMenu.install(windowScene: windowScene, items: debuggerItems)
            }
        })
    }
}

public extension View {
    @ViewBuilder
    func debugMenu(debuggerItems: [DebugMenuPresentable], enabled: Bool = true) -> some View {
        if enabled {
            modifier(DebugMenuModifier(debuggerItems: debuggerItems))
        } else {
            self
        }
    }
}
