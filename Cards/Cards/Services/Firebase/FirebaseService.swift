//
//  FirebaseService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import FirebaseRemoteConfig
import FirebaseCore

protocol FirebaseFetcher {
    func fetchCard(_ key: FirebaseKey, completion: @escaping (Result<CardFBModel, FirebaseServiceError>) -> Void)
}

final class FirebaseService: FirebaseFetcher {
    private let remoteConfig: RemoteConfig
    private let cardDecoder: CardDecodable

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig(), cardDecoder: CardDecodable = CardDecoder()) {
        self.remoteConfig = remoteConfig
        self.cardDecoder = cardDecoder
        configureRemoteConfig()
    }
    
    func fetchCard(_ key: FirebaseKey, completion: @escaping (Result<CardFBModel, FirebaseServiceError>) -> Void) {
        addListener(key, completion: completion)
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            guard let self = self else { return }
            if status == .success {
                self.remoteConfig.activate { [weak self] changed, error in
                    guard let self = self else { return }
                    if let error = error {
                        completion(.failure(.remoteConfigFetchError(error)))
                    } else {
                        do {
                            let card = try self.fetchCardFBModel(forKey: key.rawValue)
                            completion(.success(card))
                        } catch {
                            completion(.failure(.decodeError(error)))
                        }
                    }
                }
            } else if let error = error {
                completion(.failure(.remoteConfigFetchError(error)))
            }
        }
    }
    
    private func addListener(_ key: FirebaseKey, completion: @escaping (Result<CardFBModel, FirebaseServiceError>) -> Void) {
        remoteConfig.addOnConfigUpdateListener { update, error in
            self.remoteConfig.activate { [weak self] changed, error in
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(.remoteConfigFetchError(error)))
                } else {
                    do {
                        let card = try self.fetchCardFBModel(forKey: key.rawValue)
                        completion(.success(card))
                    } catch {
                        completion(.failure(.decodeError(error)))
                    }
                }
            }
        }
    }
     
     private func fetchCardFBModel(forKey key: String) throws -> CardFBModel {
         guard let stringValue = remoteConfig.configValue(forKey: key).stringValue else {
             throw FirebaseServiceError.nilValueForKey(key)
         }
         do {
             let data = Data(stringValue.utf8)
             return try cardDecoder.decodeCard(from: data)
         } catch {
             throw FirebaseServiceError.decodeError(error)
         }
     }
    
    private func configureRemoteConfig() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
}
