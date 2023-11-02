//
//  CardsListViewModel.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import Foundation

protocol CardsList {
    var item: [CardViewModel] { get set }
}

final class CardsListViewModel: CardsList {
    
    var item: [CardViewModel]
    
    init(item: [CardViewModel]) {
        self.item = item
    }
}
