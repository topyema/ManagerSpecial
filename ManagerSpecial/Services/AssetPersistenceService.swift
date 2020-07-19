//
//  AssetPersistenceService.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/19/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

protocol AssetPersistenceService {
    func imageResolver(url: String) -> Data?
    func persist(url: String, data: Data)
}

final class AssetPersistenceServiceInMemoryImpl: AssetPersistenceService {
    var cache: [String: Data] = [:]
    func imageResolver(url: String) -> Data? {
        guard let data = cache[url] else { return nil }
        return data
    }
    
    func persist(url: String, data: Data) {
        cache[url] = data
    }
}
