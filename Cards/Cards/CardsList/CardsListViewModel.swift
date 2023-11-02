//
//  CardsListViewModel.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import Foundation

protocol CardsList {
    var items: [CardViewModel] { get set }
    var updateUI: (() -> Void)? { get set }
    func load()
}

final class CardsListViewModel: CardsList {
    
    var items: [CardViewModel] {
        didSet {
            updateUI?()
        }
    }
    
    var updateUI: (() -> Void)?
    
    init(items: [CardViewModel]) {
        self.items = items
    }
}

extension CardsListViewModel {
    func load() {
        for i in 0..<6 {
            items.append(CardCollectionViewModel(name: "Name: \(i)", image: .actions))
        }
    }
}
