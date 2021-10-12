//
//  SceneDelegate.swift
//  Example
//
//  Created by Tomoya Hirano on 2020/12/06.
//

import UIKit
import Logging
import DebugMenu
import Shared
import DebugMenuConsolePlugin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        LoggingSystem.bootstrap({
            MultiplexLogHandler([
                StreamLogHandler.standardOutput(label: $0),
                WriteLogHandler.output(label: $0)
            ])
        })
        Logger(label: "dev.noppe.debugMenu.logger").info("Launch")
        
        #if DEBUG
        var sliderValue: Double = 0.1
        DebugMenu.install(windowScene: windowScene, items: [
            ConsoleDebugItem(),
            ViewControllerDebugItem<ColorViewController>(builder: { $0.init(color: .blue) }),
            ClearCacheDebugItem(),
            UserDefaultsResetDebugItem(),
            CustomDebugItem(),
            SliderDebugItem(title: "Attack Rate", current: { sliderValue }, valueLabel: { "\(String(format: "%.2f", sliderValue))%" }, range: 0.0...100.0, onChange: { sliderValue = $0 }),
            KeyValueDebugItem(title: "UserDefaults", fetcher: { completions in
                let envelops = UserDefaults.standard.dictionaryRepresentation().map({ Envelope(key: $0.key, value: "\($0.value)") })
                completions(envelops)
            }),
            GroupDebugItem(title: "Info", items: [
                AppInfoDebugItem(),
                DeviceInfoDebugItem(),
                GroupDebugItem(title: "Other", items: [
                    ViewControllerDebugItem<ColorViewController>(title: "red", builder: { $0.init(color: .red) }),
                    ViewControllerDebugItem<ColorViewController>(title: "green", builder: { $0.init(color: .green) }),
                ])
            ])
        ], dashboardItems: [
            CPUUsageDashboardItem(),
            CPUGraphDashboardItem(),
            GPUMemoryUsageDashboardItem(),
            MemoryUsageDashboardItem(),
            NetworkUsageDashboardItem(),
            FPSDashboardItem(),
            ThermalStateDashboardItem(),
            CustomDashboardItem(),
            IntervalDashboardItem(title: "Calc", name: "dev.noppe.calc"),
        ], options: [.showsWidgetOnLaunch])
        #endif
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

