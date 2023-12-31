//
//  StorageService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import UIKit

protocol CardMetadataFetching {
    func loadCard()
    func listenToUpdates()
    
    var cards: [Card] { get }
    var onCardUpdate: (() -> Void)? { get set }
}

final class StorageService: CardMetadataFetching {
    private let firebaseService: FirebaseFetcher
    private let imageDownloaderService: ImageApi
    private let limit: Int
    var cards: [Card] = [] {
        didSet {
            self.onCardUpdate?()
        }
    }
    
    var onCardUpdate: (() -> Void)?

    init(firebaseService: FirebaseFetcher,
         imageDownloaderService: ImageApi,
         limit: Int = 6) {
        self.firebaseService = firebaseService
        self.imageDownloaderService = imageDownloaderService
        self.limit = limit
    }
    
    func loadCard() {
        Task {
            let newCards = try await fetchCards()
            await MainActor.run {
                cards = newCards
            }
        }
    }
    
    func listenToUpdates() {
        Task {
            for key in FirebaseKey.allCases {
                for await _ in firebaseService.processConfigUpdates(forKey: key) {
                    loadCard()
                }
            }
        }
    }

    private func fetchCards() async throws -> [Card] {
        let cardModels = try await fetchAllCardModels()
        let sortedCardModels = sort(cardModels: cardModels, by: { $0.priority })
        let limitedCardModels = Array(sortedCardModels.prefix(limit))
        return try await downloadCards(for: limitedCardModels)
    }

    private func fetchAllCardModels() async throws -> [CardFBModel] {
        return try await FirebaseKey.allCases.asyncMap { key in
            try await fetchCard(forKey: key)
        }
    }

    private func sort(cardModels: [CardFBModel], by criteria: (CardFBModel) -> Int) -> [CardFBModel] {
        cardModels.sorted { criteria($0) < criteria($1) }
    }
    
    private func downloadCards(for cardModels: [CardFBModel]) async throws -> [Card] {
        let urls = cardModels.map { ($0.id, $0.url) }
        
        let downloadedImagesTuples = try await imageDownloaderService.downloadImages(from: urls)
        
        let downloadedImages = Dictionary(uniqueKeysWithValues: downloadedImagesTuples)

        return cardModels.compactMap { model in
            guard let image = downloadedImages[model.id] else { return nil }
            return Card(id: model.id,
                        image: image,
                        priority: model.priority,
                        name: model.name)
        }
    }
        
        private func fetchCard(forKey key: FirebaseKey) async throws -> CardFBModel {
            return try await firebaseService.fetchCard(key)
        }
    }
