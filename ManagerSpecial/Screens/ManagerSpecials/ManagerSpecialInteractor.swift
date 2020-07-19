//
//  ManagerSpecialInteractor.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/18/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation

final class ManagerSpecialInteractor: ManagerSpecialViewControllerListener {
    
    private let tileLayoutComputer: TileLayoutManager
    private let service: ManagerSpecialService

    var router: ManagerSpecialRouting?    
    weak var view: ManagerSpecialViewControllerInput?
    
    init(tileLayoutComputer: TileLayoutManager,
         service: ManagerSpecialService) {
        self.service = service
        self.tileLayoutComputer = tileLayoutComputer
    }
    
    private func setup() {
        view?.updateView(status: .loading)
        service.fetch({ [weak self] status in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch status {
                case .SUCCESS(let response):
                    strongSelf.tileLayoutComputer.update(response.managerSpecials, canvasUnit: response.canvasUnit)
                    strongSelf.view?.updateView(status: .loaded(strongSelf.tileLayoutComputer, response.managerSpecials))
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
}
