//
//  CardsListViewModel.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import Foundation

protocol CardsList {
    var items: [CardViewModel] { get set }
}

final class CardsListViewModel: CardsList {
    
    var items: [CardViewModel]
    
    init(items: [CardViewModel]) {
        self.items = items
    }
}
