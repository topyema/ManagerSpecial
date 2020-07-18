//
//  Container.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

typealias FactoryClosure = (ContainerProtocol) -> AnyObject

protocol ContainerProtocol {
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure)
    func resolve<Service>(type: Service.Type) -> Service?
}

final class Container: ContainerProtocol, ManagerSpecialDependency {
     
    var servicesFactory: [String: FactoryClosure] = [:]
    var services: [String: AnyObject] = [:]
    
    func register<Service>(type: Service.Type, factoryClosure: @escaping FactoryClosure) {
        servicesFactory["\(type)"] = factoryClosure
    }

    func resolve<Service>(type: Service.Type) -> Service? {
        if services["\(type)"] == nil {
            services["\(type)"] = servicesFactory["\(type)"]?(self)
        }
        return services["\(type)"] as? Service
    }

    //MARK: - ManagerSpecialDependency
    var service: ManagerSpecialService {
        return resolve(type: ManagerSpecialService.self)!
    }

    var tileLayoutComputer: TileLayoutComputer {
        return resolve(type: TileLayoutComputer.self)!
    }
}
