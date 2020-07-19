//
//  ManagerSpecialViewController.swift
//  ManagerSpecial
//
//  Created by Ye Ma on 7/17/20.
//  Copyright © 2020 Ye Ma. All rights reserved.
//

import UIKit

protocol ManagerSpecialViewControllerInput: AnyObject {
    func updateView(status: ManagerSpecialViewControllerViewStatus)
}

protocol ManagerSpecialViewControllerListener: AnyObject {
    func didBecomeActive()
    func resolveImage(with url: String, complete: @escaping CompleteImageLoadingBlock)
}

protocol ManagerSpecialViewControllerViewModel: AnyObject {
    func sizeForIndex(_ index: Int, screenWidth: Int, padding: Int, spacing: Int) -> CGSize
}

enum ManagerSpecialViewControllerViewStatus {
    case loading
    case loaded(ManagerSpecialViewControllerViewModel, [ManagerSpecial])
    case failed(ServiceError)
}

final class ManagerSpecialViewController: UIViewController, ManagerSpecialViewControllerInput {
    
    enum Constants {
        static let title = "Manager's Special"
        static let minimumLineSpacing: CGFloat = 20
        static let minimumInterItemSpacing: CGFloat = 10
        static let padding: CGFloat = 10
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var failureLabel: UILabel!

    private var viewModel: ManagerSpecialViewControllerViewModel?
    private var list: [ManagerSpecialViewModel] = []
    var listener: ManagerSpecialViewControllerListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        configView()

        listener?.didBecomeActive()
    }
    
    func updateView(status: ManagerSpecialViewControllerViewStatus) {
        switch status {
        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            failureLabel.isHidden = true
        case .loaded(let viewModel, let list):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            failureLabel.isHidden = true
            self.viewModel = viewModel
            self.list = list
        case .failed(let error):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            failureLabel.isHidden = false
            failureLabel.text = error.description
        }
        self.collectionView.reloadData()
    }
    
    private func configView() {
        self.navigationItem.title = Constants.title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension ManagerSpecialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagerSpecialCollectionViewCell.uniqueIdentifier, for: indexPath)
        if let cell = cell as? ManagerSpecialUIConfigurable,
            let size = viewModel?.sizeForIndex(indexPath.row, screenWidth: Int(collectionView.bounds.size.width), padding: Int(Constants.padding), spacing: Int(Constants.minimumInterItemSpacing)) {
            cell.config(with: list[indexPath.row], cellSize: size)
            listener?.resolveImage(with: list[indexPath.row].imageUrl) { image in
                guard let image = image else { return }
                cell.configImage(with: image)
            }
        }
        return cell
    }
}

extension ManagerSpecialViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let size = viewModel?.sizeForIndex(indexPath.row, screenWidth: Int(collectionView.bounds.size.width), padding: Int(Constants.padding), spacing: Int(Constants.minimumInterItemSpacing)) else {
            return CGSize.zero
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumInterItemSpacing
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
    }
}
