//
//  ManagerSpeicalComponent.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/18/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

protocol ManagerSpecialDependency: AnyObject {
    var service: ManagerSpecialService { get }
    var assetDeliveryService: AssetDeliveryService { get }
}

protocol ManagerSpecialLayoutDependency {
    var tileLayoutManager: TileLayoutManager { get }
}

final class ManagerSpecialComponent: ManagerSpecialDependency, ManagerSpecialLayoutDependency {
    
    var dependency: ManagerSpecialDependency
    init(dependency: ManagerSpecialDependency) {
        self.dependency = dependency
    }
    
    var service: ManagerSpecialService {
        return dependency.service
    }
    
    var assetDeliveryService: AssetDeliveryService {
        return dependency.assetDeliveryService
    }

    var tileLayoutManager: TileLayoutManager {
        return TileLayoutManagerImpl()
    }
    
}
