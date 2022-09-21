//
//  SceneDelegate.swift
//  Movie
//
//  Created by Yevhen Tretiakov on 19.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupRootView(scene: scene)
    }
    
    private func setupRootView(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DefaultFeedBuilder().createFeedModule()
        window?.makeKeyAndVisible()
    }
}
