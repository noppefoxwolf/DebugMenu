//
//  File.swift
//
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import Foundation
import SwiftUI

@available(iOSApplicationExtension, unavailable)
struct DebugMenuModifier: ViewModifier {
    internal init(
        debuggerItems: [DebugItem],
        complications: [ComplicationPresentable],
        options: [Options]
    ) {
        self.debuggerItems = debuggerItems
        self.complications = complications
        self.options = options
    }

    let debuggerItems: [DebugItem]
    let complications: [ComplicationPresentable]
    let options: [Options]

    func body(content: Content) -> some View {
        content.onAppear(perform: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                DebugMenu.install(
                    windowScene: windowScene,
                    items: debuggerItems,
                    complications: complications,
                    options: options
                )
            }
        })
    }
}

@available(iOSApplicationExtension, unavailable)
public extension View {
    @ViewBuilder
    func debugMenu(
        debuggerItems: [DebugItem] = [],
        complications: [ComplicationPresentable] = [],
        options: [Options] = Options.default,
        enabled: Bool = true
    ) -> some View {
        if enabled {
            modifier(
                DebugMenuModifier(
                    debuggerItems: debuggerItems,
                    complications: complications,
                    options: options
                )
            )
        } else {
            self
        }
    }
}
