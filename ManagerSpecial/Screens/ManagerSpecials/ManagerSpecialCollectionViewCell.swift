//
//  UICollectionViewCell.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

protocol ManagerSpecialViewModel {
    var displayName: String { get }
    var imageUrl: String  { get }
    var originalPrice: String  { get }
    var price: String  { get }
    var heightInUnit: Int { get }
}

extension ManagerSpecial: ManagerSpecialViewModel {}

protocol ManagerSpecialUIConfigurable {
    func config(with model: ManagerSpecialViewModel, cellSize: CGSize)
}

final class ManagerSpecialCollectionViewCell: UICollectionViewCell, ManagerSpecialUIConfigurable {
    static let uniqueIdentifier = "ManagerSpecialCollectionViewCell"

    enum Constants {
        static let cornerRadius: CGFloat = 10.0
        static let padding: CGFloat = 20.0
    }
    
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var displayNameWidthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func config(with model: ManagerSpecialViewModel, cellSize: CGSize) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(model.originalPrice)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        originalPrice.attributedText = attributeString
        price.text = "$\(model.price)"
        displayName.text = model.displayName
        displayNameWidthConstraint.constant = cellSize.width - Constants.padding * 2
        
        DispatchQueue.global().async {
            if let URL = URL(string: model.imageUrl), let data = try? Data(contentsOf: URL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        
    }
}
