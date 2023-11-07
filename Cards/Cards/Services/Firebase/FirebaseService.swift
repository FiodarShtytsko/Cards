//
//  FirebaseService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import FirebaseRemoteConfig
import FirebaseCore

protocol FirebaseFetcher {
    func fetchCard(_ key: FirebaseKey) async throws -> CardFBModel
    func processConfigUpdates(forKey key: FirebaseKey) -> AsyncStream<CardFBModel>
}

final class FirebaseService: FirebaseFetcher {
    private let remoteConfig: RemoteConfig
    private let cardDecoder: CardDecodable

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig(), cardDecoder: CardDecodable = CardDecoder()) {
        self.remoteConfig = remoteConfig
        self.cardDecoder = cardDecoder
        configureRemoteConfig()
    }
    
    func fetchCard(_ key: FirebaseKey) async throws -> CardFBModel {
        let _ = try await fetchRemoteConfig()
        return try fetchCardFBModel(forKey: key.rawValue)
    }
    
    func fetchRemoteConfig() async throws -> Void {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
                guard let self = self else { return }
                if status == .success {
                    self.remoteConfig.activate { changed, error in
                        if let error = error {
                            continuation.resume(throwing: FirebaseServiceError.remoteConfigFetchError(error))
                        } else {
                            continuation.resume(returning: ())
                        }
                    }
                } else if let error = error {
                    continuation.resume(throwing: FirebaseServiceError.remoteConfigFetchError(error))
                }
            }
        }
    }
     
     private func fetchCardFBModel(forKey key: String) throws -> CardFBModel {
         guard let stringValue = remoteConfig.configValue(forKey: key).stringValue else {
             throw FirebaseServiceError.nilValueForKey(key)
         }
         let data = Data(stringValue.utf8)
         return try cardDecoder.decodeCard(from: data)
     }
    
    func processConfigUpdates(forKey key: FirebaseKey) -> AsyncStream<CardFBModel> {
        AsyncStream<CardFBModel> { continuation in
            let listener = remoteConfig.addOnConfigUpdateListener { [weak self] update, error in
                if let error = error {
                    let firebaseError = FirebaseServiceError.remoteConfigFetchError(error)
                    continuation.finish()
                } else {
                    self?.remoteConfig.activate { (changed, error) in
                        if let error = error {
                            continuation.finish()
                        } else {
                            do {
                                let card = try self?.fetchCardFBModel(forKey: key.rawValue)
                                if let card = card {
                                    continuation.yield(card)
                                } else {
                                    continuation.finish()
                                }
                            } catch {
                                continuation.finish()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func configureRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
}
