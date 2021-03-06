//
//  SceneDelegate.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)

        let container = Container()
        container.register(type: ManagerSpecialService.self) { _ in
            return ManagerSpecialServiceImpl()
        }
        container.register(type: AssetPersistenceService.self) { _ -> AnyObject in
            return AssetPersistenceServiceInMemoryImpl()
        }
        container.register(type: AssetDeliveryService.self) { container -> AnyObject in
            let persistenService = container.resolve(type: AssetPersistenceService.self)!
            return AssetDeliveryServiceImpl(persistenceService: persistenService)
        }
        
        let rootVC = ManagerSpeicalBuilder(dependency: container).build()
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
    }
}

