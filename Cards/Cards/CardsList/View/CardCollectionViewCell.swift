//
//  CardCollectionViewCell.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import UIKit


protocol CardViewModel {
    var image: UIImage { get }
    var name: String { get }
}

struct CardCollectionViewModel: CardViewModel {
    var image: UIImage
    var name: String
}

final class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configure(_ viewModel: CardViewModel) {
        imageView.image = viewModel.image
        nameLabel.text = viewModel.name
    }
}
