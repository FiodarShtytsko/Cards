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
    
    private let storage: CardMetadataFetching
    
    init(items: [CardViewModel]) {
        self.items = items
        self.storage = StorageService(firebaseService: FirebaseService(),
                                      imageDownloaderService: ImageService())
    }
}

extension CardsListViewModel {
    func load() {
        
        
        Task {
            do {
                storage
                let cards = try await self.storage.fetchCards()
                await MainActor.run {
                    self.items = cards.map { CardCollectionViewModel(image: $0.images, name: "Priority: \($0.priority)")}
                }
            } catch {
                await MainActor.run {
                    print("Error loading images: \(error)")
                }
            }
        }
    }
}
