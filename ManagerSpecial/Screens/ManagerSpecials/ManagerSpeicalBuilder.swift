//
//  ManagerSpeicalBuilder.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/18/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

final class ManagerSpeicalBuilder {
    
    var dependency: ManagerSpecialDependency
    
    init(dependency: ManagerSpecialDependency) {
        self.dependency = dependency
    }
    
    func build() -> UIViewController {
        let component = ManagerSpecialComponent(dependency: dependency)
        let view = ManagerSpecialViewController()
        let interactor = ManagerSpecialInteractor(tileLayoutManager: component.tileLayoutManager,
                                                  service: component.service,
                                                  assetDeliveryService: component.assetDeliveryService)
        let router = ManagerSpecialRouter(view: view)

        view.listener = interactor
        interactor.view = view
        interactor.router = router
        
        return view
    }
}
