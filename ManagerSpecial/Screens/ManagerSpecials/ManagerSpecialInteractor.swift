//
//  ManagerSpecialInteractor.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/18/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation
import UIKit

final class ManagerSpecialInteractor: ManagerSpecialViewControllerListener {
   
    private let tileLayoutManager: TileLayoutManager
    private let service: ManagerSpecialService
    private let assetDeliveryService: AssetDeliveryService

    var router: ManagerSpecialRouting?    
    weak var view: ManagerSpecialViewControllerInput?
    
    init(tileLayoutManager: TileLayoutManager,
         service: ManagerSpecialService,
         assetDeliveryService: AssetDeliveryService) {
        self.service = service
        self.tileLayoutManager = tileLayoutManager
        self.assetDeliveryService = assetDeliveryService
    }
    
    private func setup() {
        view?.updateView(status: .loading)
        service.fetch({ [weak self] status in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch status {
                case .SUCCESS(let response):
                    strongSelf.tileLayoutManager.update(response.managerSpecials, canvasUnit: response.canvasUnit)
                    strongSelf.view?.updateView(status: .loaded(strongSelf.tileLayoutManager, response.managerSpecials))
                case .FAILURE(let error):
                    strongSelf.view?.updateView(status: .failed(error))
                }
            }
        })
    }
    
    //MARK: - ManagerSpecialViewControllerListener
    func didBecomeActive() {
        setup()
    }
    
    func resolveImage(with url: String, complete: @escaping CompleteImageLoadingBlock) {
        assetDeliveryService.imageByUrlString(url, complete: complete)
    }
}
