//
//  TileLayoutComputer.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import Foundation
import UIKit

protocol FlexibleSize {
    var widthInUnit: Int { get }
    var heightInUnit: Int { get }
}

typealias WeightAndTotal = (weight: Int, total: Int)

extension ManagerSpecial: FlexibleSize {}

protocol TileLayoutComputer: ManagerSpecialViewControllerViewModel {
    var canvasUnit: Int { get }
    func update(_ list: [FlexibleSize], canvasUnit: Int)
    func sizeForIndex(_ index: Int, screenWidth: Int, padding: Int, spacing: Int) -> CGSize
}

final class TileLayoutComputerImpl: TileLayoutComputer {
    
    private var list: [FlexibleSize] = []
    private var rowByIndex: [Int] = []
    
    private func recalcuate() -> [Int] {
        var leftInCurrentRow = canvasUnit
        var row = 0
        var index = 0
        var result = [Int]()
        
        while index < list.count {
            leftInCurrentRow -= list[index].widthInUnit
            if leftInCurrentRow >= 0 {
                result.append(row)
                index += 1
            } else {
                row += 1
                leftInCurrentRow = canvasUnit
            }
        }
        return result
    }
    
    private func countForIndex(_ index: Int) -> Int {
        guard index < rowByIndex.count else { return 0 }
        let row = rowByIndex[index]
        return rowByIndex.filter{ $0 == row }.count
    }
    
    private func weightForIndex(_ index: Int) -> WeightAndTotal {
        let weight = list[index].widthInUnit
        let row = rowByIndex[index]
        var total = 0
        for i in 0..<rowByIndex.count {
            if rowByIndex[i] == row {
                total += list[i].widthInUnit
            }
        }
        return (weight: weight, total: total)
    }

    //MARK: - TitleLayoutComputer
    var canvasUnit: Int = 0

    func update(_ list: [FlexibleSize], canvasUnit: Int) {
        self.canvasUnit = canvasUnit
        self.list = list
        rowByIndex = recalcuate()
    }
    
    func sizeForIndex(_ index: Int, screenWidth: Int, padding: Int, spacing: Int) -> CGSize {
        let pixelPerUnit = screenWidth / canvasUnit
        let itemCount = countForIndex(index)
        let weightAndTotal = weightForIndex(index)
        let width = (screenWidth - padding * 2 + (itemCount - 1) * spacing) * weightAndTotal.weight / weightAndTotal.total
        let height = pixelPerUnit * list[index].heightInUnit
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
}
