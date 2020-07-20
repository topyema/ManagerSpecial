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
    func configImage(with image: UIImage)
}

final class ManagerSpecialCollectionViewCell: UICollectionViewCell, ManagerSpecialUIConfigurable {
    static let uniqueIdentifier = "ManagerSpecialCollectionViewCell"

    enum Constants {
        static let cornerRadius: CGFloat = 10.0
        static let displayNamePadding: CGFloat = 20.0
        static let padding: CGFloat = 10.0
        static let imageSize: CGFloat = 80.0
    }
    
    private var displayNameWidthConstraint: NSLayoutConstraint?
    
    private let originalPrice: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let displayName: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius

        addSubview(originalPrice)
        addSubview(price)
        addSubview(displayName)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            originalPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            originalPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.padding),
            price.topAnchor.constraint(equalTo: originalPrice.bottomAnchor, constant: Constants.padding),
            price.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.padding),
            displayName.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            displayName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.padding),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.padding),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.padding),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
        
        displayNameWidthConstraint = displayName.widthAnchor.constraint(equalToConstant: 0)
        displayNameWidthConstraint?.isActive = false
    }
    
    func config(with model: ManagerSpecialViewModel, cellSize: CGSize) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$\(model.originalPrice)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        originalPrice.attributedText = attributeString
        price.text = "$\(model.price)"
        displayName.text = model.displayName
        displayNameWidthConstraint?.constant = cellSize.width - Constants.displayNamePadding * 2
        displayNameWidthConstraint?.isActive = true
    }
    
    func configImage(with image: UIImage) {
        self.imageView.image = image
    }
}
