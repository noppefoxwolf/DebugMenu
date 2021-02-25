//
//  CustomActivityController.swift
//  DebugMenu
//
//  Created by Tomoya Hirano on 2020/12/23.
//

import UIKit

class CustomActivityViewController: UIActivityViewController {

    private let controller: UIViewController

    required init(controller: UIViewController) {
        self.controller = controller
        super.init(activityItems: [], applicationActivities: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let subViews = self.view.subviews
        for view in subViews {
            view.removeFromSuperview()
        }

        self.addChild(controller)
        self.view.addSubview(controller.view)
    }

}
