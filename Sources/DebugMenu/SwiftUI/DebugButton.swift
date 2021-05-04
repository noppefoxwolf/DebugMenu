//
//  File.swift
//  
//
//  Created by Tomoya Hirano on 2021/05/05.
//

import UIKit
import SwiftUI

struct DebugButton: UIViewControllerRepresentable {
    internal init(debuggerItems: [DebugMenuPresentable]) {
        self.debuggerItems = debuggerItems
    }
    
    let debuggerItems: [DebugMenuPresentable]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        DebugButtonViewController(debuggerItems: debuggerItems)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
