//
//  ViewController.swift
//  UIKitExample
//
//  Created by Tomoya Hirano on 2021/05/26.
//

import UIKit
import DebugMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func calculate(_ sender: Any) {
        let tracker = IntervalTracker(name: "dev.noppe.calc")
        tracker.track(.begin)
        let _ = (0..<10000000).reduce(0, +)
        tracker.track(.end)
    }
}

