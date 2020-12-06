//
//  CaseSelectableDebugItem.swift
//  App
//
//  Created by Tomoya Hirano on 2020/05/14.
//

import UIKit

public struct CaseSelectableDebugItem<T: CaseIterable & RawRepresentable>: DebugMenuPresentable where T.RawValue: Equatable {
    public init(currentValue: T, didSelected: @escaping (T) -> Void) {
        self.currentValue = currentValue
        self.didSelected = didSelected
    }
    
    public let currentValue: T
    public let didSelected: (T) -> Void
    public var debuggerItemTitle: String { String(describing: T.self) }
    
    public func didSelectedDebuggerItem(_ controller: UIViewController, completionHandler: @escaping (InAppDebuggerResult) -> Void) {
        let vc = CaseSelectableTableController<T>(currentValue: currentValue, didSelected: didSelected)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}

