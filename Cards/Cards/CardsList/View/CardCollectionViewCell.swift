//
//  CardCollectionViewCell.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import UIKit


protocol CardViewModel {
    var name: String { get }
    var image: UIImage { get }
}

struct CardCollectionViewModel: CardViewModel {
    var name: String
    var image: UIImage
}

final class CardCollectionViewCell: UICollectionViewCell {
    
    
    func configure(_ viewModel: CardViewModel) {
    
    }
}
