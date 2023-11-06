//
//  StorageService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import UIKit

protocol CardMetadataFetching {
    func fetchCards() async throws -> [Card]
}

final class StorageService: CardMetadataFetching {
    private let firebaseService: FirebaseFetcher
    private let imageDownloaderService: ImageApi
    private let limit: Int

    init(firebaseService: FirebaseFetcher,
         imageDownloaderService: ImageApi,
         limit: Int = 6) {
        self.firebaseService = firebaseService
        self.imageDownloaderService = imageDownloaderService
        self.limit = limit
    }

    func fetchCards() async throws -> [Card] {
        let cardModels = try await fetchAllCardModels()
        let sortedCardModels = sort(cardModels: cardModels, by: { $0.priority })
        let limitedCardModels = Array(sortedCardModels.prefix(limit))
        return try await downloadImages(for: limitedCardModels)
    }

    private func fetchAllCardModels() async throws -> [CardFBModel] {
        return try await FirebaseKey.allCases.asyncMap { key in
            try await fetchCard(forKey: key)
        }
    }

    private func sort(cardModels: [CardFBModel], by criteria: (CardFBModel) -> Int) -> [CardFBModel] {
        cardModels.sorted { criteria($0) < criteria($1) }
    }

    private func downloadImages(for cardModels: [CardFBModel]) async throws -> [Card] {
        let urls = cardModels.map { $0.url }
        let downloadedImages = try await imageDownloaderService.downloadImages(from: urls)
        return zip(cardModels, downloadedImages).map { Card(images: $1, priority: $0.priority) }
    }

    private func fetchCard(forKey key: FirebaseKey) async throws -> CardFBModel {
        try await withCheckedThrowingContinuation { continuation in
            firebaseService.fetchCard(key) { result in
                switch result {
                case .success(let cardModel):
                    continuation.resume(returning: cardModel)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
