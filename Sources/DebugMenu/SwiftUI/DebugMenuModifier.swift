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
    let size: CGSize = .init(width: 44, height: 44)
    let margin: CGFloat = 16
    @State var position: CGPoint = .init(x: 16 + 22, y: 16 + 22)
    @State var alignment: Alignment = .center
    
    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: alignment) {
                content
                DebugButton(debuggerItems: debuggerItems)
                    .frame(width: size.width, height: size.height)
                    .position(x: position.x, y: position.y)
                    .animation(.spring())
                    .gesture(dragGesture(parentSize: geometry.size))
            }
        })
    }
    
    func dragGesture(parentSize: CGSize) -> some Gesture {
        DragGesture()
            .onChanged{ value in
                position = CGPoint(
                    x: value.startLocation.x + value.translation.width - (size.width / 2),
                    y: value.startLocation.y + value.translation.height - (size.height / 2)
                )
            }
            .onEnded{ value in
                print(parentSize)
                
                let x: CGFloat = {
                    switch position.x {
                    case 0..<parentSize.width / 2:
                        return margin + size.width / 2
                    default:
                        return parentSize.width - margin - size.width / 2
                    }
                }()
                position = .init(x: x, y: position.y)
            }
    }
}

public extension View {
    func debugMenu(debuggerItems: [DebugMenuPresentable]) -> some View {
        #if DEBUG
        return modifier(DebugMenuModifier(debuggerItems: debuggerItems))
        #else
        return self
        #endif
    }
}
