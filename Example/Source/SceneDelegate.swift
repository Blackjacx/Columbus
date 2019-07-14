//
//  SceneDelegate.swift
//  ColumbusExample
//
//  Created by Stefan Herold on 13.07.19.
//  Copyright © 2019 CodingCobra. All rights reserved.
//

import UIKit
import SwiftUI
import Columbus

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            Columbus.config = CountryPickerConfig()
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: CountryListView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

public struct CountryPickerConfig: Configuration {
    public var shadowRadius: Length = 10.0
    public var textAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15)]
    public var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    public var rasterSize: CGFloat = 12.0
    public var separatorInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: rasterSize * 3.7, bottom: 0, right: rasterSize)
    }
    public var searchBarPlaceholder: String? = "Search"
    public var flagWidth: Length = 30

    public init() {}
}
