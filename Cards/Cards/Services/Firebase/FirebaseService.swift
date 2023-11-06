//
//  FirebaseService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import FirebaseRemoteConfig
import FirebaseCore

protocol FirebaseFetcher {
    func fetchCard(_ key: FirebaseKey, completion: @escaping (Result<Photo, FirebaseServiceError>) -> Void)
}

final class FirebaseService: FirebaseFetcher {
    private let remoteConfig: RemoteConfig
    private let photoDecoder: PhotoDecodable

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig(), photoDecoder: PhotoDecodable = PhotoDecoder()) {
        self.remoteConfig = remoteConfig
        self.photoDecoder = photoDecoder
        configureRemoteConfig()
    }
    
    func fetchCard(_ key: FirebaseKey, completion: @escaping (Result<Photo, FirebaseServiceError>) -> Void) {
         remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
             guard let self = self else { return }
             if status == .success {
                 self.remoteConfig.activate { [weak self] changed, error in
                     guard let self = self else { return }
                     if let error = error {
                         completion(.failure(.remoteConfigFetchError(error)))
                     } else {
                         do {
                             let photo = try self.fetchPhoto(forKey: key.rawValue)
                             completion(.success(photo))
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
     
     private func fetchPhoto(forKey key: String) throws -> Photo {
         guard let stringValue = remoteConfig.configValue(forKey: key).stringValue else {
             throw FirebaseServiceError.nilValueForKey(key)
         }
         do {
             let data = Data(stringValue.utf8)
             return try photoDecoder.decodePhoto(from: data)
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
