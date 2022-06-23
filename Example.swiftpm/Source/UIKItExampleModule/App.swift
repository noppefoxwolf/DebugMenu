import UIKit
import DebugMenu
import Shared

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.sceneClass = UIWindowScene.self
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
        
        DebugMenu.install(
            windowScene: windowScene,
            items: [
                AlertDebugMenu(),
                ViewControllerDebugItem<ColorViewController>(builder: { $0.init(color: .blue) }),
                ClearCacheDebugItem(),
                UserDefaultsResetDebugItem(),
                CustomDebugItem(),
                SliderDebugItem(title: "Attack Rate", current: { 0.1 }, range: 0.0...100.0, onChange: { value in print(value) }),
                KeyValueDebugItem(title: "UserDefaults", fetcher: {
                    return UserDefaults.standard.dictionaryRepresentation().map({ Envelope(key: $0.key, value: "\($0.value)") })
                }),
                GroupDebugItem(title: "Info", items: [
                    AppInfoDebugItem(),
                    DeviceInfoDebugItem(),
                ]),
            ], dashboardItems: [
                CPUUsageDashboardItem(),
                CPUGraphDashboardItem(),
                GPUMemoryUsageDashboardItem(),
                MemoryUsageDashboardItem(),
                NetworkUsageDashboardItem(),
                FPSDashboardItem(),
                ThermalStateDashboardItem(),
                CustomDashboardItem(),
                IntervalDashboardItem(title: "Reduce time", name: "dev.noppe.calc")
            ], options: [.showsWidgetOnLaunch]
        )
    }
}

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }
}

struct AlertDebugMenu: DebugItem {
  var debugItemTitle: String = "Alert"
  var action: DebugItemAction = .didSelect { @MainActor controller in
    let alert = UIAlertController(title: "Input Text", message: nil, preferredStyle: .alert)
    alert.addTextField()
    alert.addAction(.init(title: "OK", style: .default))
    controller.present(alert, animated: true)
    return .success()
  }
}
