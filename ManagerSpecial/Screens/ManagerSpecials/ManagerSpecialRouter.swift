//
//  ManagerSpecialRouter.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/18/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

protocol ManagerSpecialRouting: AnyObject {}

final class ManagerSpecialRouter: ManagerSpecialRouting {
    
    var view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
}
