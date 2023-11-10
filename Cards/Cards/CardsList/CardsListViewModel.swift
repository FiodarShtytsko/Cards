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
    
    private var storage: CardMetadataFetching
    
    init(items: [CardViewModel]) {
        self.items = items
        self.storage = StorageService(firebaseService: FirebaseService(),
                                      imageDownloaderService: ImageService())
    }
}

extension CardsListViewModel {
    func load() {
        
        storage.onCardUpdate = {
            self.items = self.storage.cards.map { CardCollectionViewModel(image: $0.image, name: $0.name)}
        }
        
        storage.listenToUpdates()
        storage.loadCard()
    }
}
