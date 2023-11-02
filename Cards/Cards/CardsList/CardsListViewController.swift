//
//  ViewController.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import UIKit

final class CardsListViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel: CardsList!


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setup() {
        collectionView.register(CardCollectionViewCell.self)
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
