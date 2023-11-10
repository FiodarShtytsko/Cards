//
//  ViewController.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import UIKit

final class CardsListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No cards available"
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        return label
    }()
    
    private var viewModel: CardsList!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel = CardsListViewModel(items: [])
        
        viewModel.updateUI = { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
            self.emptyStateLabel.isHidden = !self.viewModel.items.isEmpty
        }
        viewModel.load()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        viewModel.updateUI?()
    }
    
    private func setup() {
        collectionView.register(CardCollectionViewCell.self)
        
        view.addSubview(emptyStateLabel)
           NSLayoutConstraint.activate([
               emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
    }
}

extension CardsListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.items[indexPath.row]
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(model)
        return cell
    }
}

extension CardsListViewController: UICollectionViewDelegateFlowLayout {
    func numberOfColumns() -> Int {
        return UIDevice.current.orientation.isLandscape ? 2 : 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / CGFloat(numberOfColumns())) - 5
        return CGSize(width: width, height: width)
    }
}
