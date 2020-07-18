//
//  ManagerSpecial.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

struct ManagerSpecialResponse: Codable {
    var canvasUnit: Int
    var managerSpecials: [ManagerSpecial]
}

struct ManagerSpecial: Codable {
    var displayName: String
    var heightInUnit: Int
    var widthInUnit: Int
    var imageUrl : String
    var originalPrice: String
    var price: String

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case heightInUnit = "height"
        case widthInUnit = "width"
        case imageUrl = "imageUrl"
        case originalPrice = "original_price"
        case price = "price"
    }
}

