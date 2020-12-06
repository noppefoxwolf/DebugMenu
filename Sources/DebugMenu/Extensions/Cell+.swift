//
//  Cell.swift
//  
//
//  Created by Tomoya Hirano on 2019/12/07.
//  Copyright © 2019 Tomoya Hirano. All rights reserved.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: NSStringFromClass(cellClass))
    }
    
    func dequeue<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: NSStringFromClass(cellClass), for: indexPath) as! T
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func register<T: UICollectionReusableView>(_ cellClass: T.Type) {
        register(cellClass, forSupplementaryViewOfKind: cellClass.elementKind, withReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as! T
    }
    
    func dequeue<T: UICollectionReusableView>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: cellClass.elementKind, withReuseIdentifier: String(describing: cellClass), for: indexPath) as! T
    }
}

public extension UICollectionReusableView {
    static var elementKind: String {
        String(describing: Self.self)
    }
}
