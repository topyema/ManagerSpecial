//
//  AsssetDeliveryKit.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/19/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

typealias CompleteImageLoadingBlock = (UIImage?)->Void

protocol AssetDeliveryService {
    func imageByUrlString(_ url: String, complete: @escaping CompleteImageLoadingBlock)
}

final class AssetDeliveryServiceImpl: AssetDeliveryService {
    var persistenceService: AssetPersistenceService
    init(persistenceService: AssetPersistenceService) {
        self.persistenceService = persistenceService
    }
    
    func imageByUrlString(_ url: String, complete: @escaping CompleteImageLoadingBlock) {
        guard let data = persistenceService.imageResolver(url: url) else {
            DispatchQueue.global().async {
                if let URL = URL(string: url),
                    let data = try? Data(contentsOf: URL) {
                    DispatchQueue.main.async {
                        self.persistenceService.persist(url: url, data: data)
                        complete(UIImage(data: data))
                    }
                }
            }
            return
        }
        complete(UIImage(data: data))
    }
}
