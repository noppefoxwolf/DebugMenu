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

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
