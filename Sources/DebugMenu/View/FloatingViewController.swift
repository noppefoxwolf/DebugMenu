import Combine
import UIKit

internal class FloatingViewController: UIViewController {
    class View: UIView, TouchThrowing {}
    private let launchView: LaunchView
    private let widgetView: WidgetView
    private let debuggerItems: [DebugItem]
    private var cancellables: Set<AnyCancellable> = []
    private let options: [Options]

    init(
        debuggerItems: [DebugItem],
        dashboardItems: [DashboardItem],
        options: [Options]
    ) {
        self.debuggerItems = debuggerItems
        self.widgetView = .init(dashboardItems: dashboardItems)
        self.options = options

        launchView = .init(
            image:
                options.compactMap { option -> UIImage? in
                    if case .launchIcon(let launchIcon) = option {
                        return launchIcon.image
                    }
                    return nil
                }
                .first
        )

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func loadView() {
        view = View(frame: .null)

        view.addSubview(launchView)
        view.addSubview(widgetView)

        launchView.isHidden = true
        widgetView.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bug: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            launchView.addGestureRecognizer(gesture)

            let initialPosition =
                options
                .compactMap { option -> Options.LaunchIcon.Position? in
                    if case .launchIcon(let launchIcon) = option {
                        return launchIcon.initialPosition
                    }
                    return nil
                }
                .first ?? .bottomTrailing

            gesture.moveInitialPosition(initialPosition)

            let longPress = UILongPressGestureRecognizer()
            longPress.publisher(for: \.state).filter({ $0 == .began })
                .sink { [weak self] _ in
                    self?.presentMenu()
                }
                .store(in: &cancellables)
            launchView.addGestureRecognizer(longPress)

            launchView.addAction(
                .init(handler: { [weak self] _ in
                    guard let self = self else { return }
                    let vc = InAppDebuggerViewController(
                        debuggerItems: self.debuggerItems,
                        options: self.options
                    )
                    let nc = UINavigationController(rootViewController: vc)
                    nc.modalPresentationStyle = .fullScreen
                    if #available(iOS 15, *) {
                        nc.modalPresentationStyle = .pageSheet
                        nc.sheetPresentationController?.selectedDetentIdentifier = .medium
                        nc.sheetPresentationController?.detents = [.medium(), .large()]
                        nc.popoverPresentationController?.sourceView = self.launchView
                        self.present(nc, animated: true, completion: nil)
                    } else {
                        let ac = CustomActivityViewController(controller: nc)
                        ac.popoverPresentationController?.sourceView = self.launchView
                        self.present(ac, animated: true, completion: nil)
                    }
                })
            )
        }

        widget: do {
            let gesture = FloatingItemGestureRecognizer(groundView: self.view)
            widgetView.addGestureRecognizer(gesture)
            gesture.moveInitialPosition(.topLeading)
        }

        if options.contains(where: { $0.isShowsWidgetOnLaunch }) {
            widgetView.show()
        } else {
            widgetView.hide()
        }
        launchView.isHidden = false
    }

    private func presentMenu() {
        let sheet = UIAlertController(title: "DebugMenu", message: nil, preferredStyle: .alert)
        sheet.addAction(
            .init(
                title: .hideUntilNextLaunch,
                style: .destructive,
                handler: { [weak self] _ in
                    self?.launchView.isHidden = true
                    self?.widgetView.hide()
                }
            )
        )
        if widgetView.isHidden {
            sheet.addAction(
                .init(
                    title: .showWidget,
                    style: .default,
                    handler: { [weak self] _ in
                        self?.widgetView.show()
                    }
                )
            )
        } else {
            sheet.addAction(
                .init(
                    title: .hideWidget,
                    style: .destructive,
                    handler: { [weak self] _ in
                        self?.widgetView.hide()
                    }
                )
            )
        }
        sheet.addAction(.init(title: .cancel, style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
}
