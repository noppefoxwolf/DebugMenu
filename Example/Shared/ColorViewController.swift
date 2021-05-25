//
//  ColorViewController.swift
//  Shared
//
//  Created by Tomoya Hirano on 2021/05/26.
//

import UIKit

public final class ColorViewController: UIViewController {
    
    private let color: UIColor
    
    public init(color: UIColor) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        color = .red
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color
    }
}

