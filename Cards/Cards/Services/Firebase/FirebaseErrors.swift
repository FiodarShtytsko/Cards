//
//  FirebaseErrors.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

enum FirebaseServiceError: Error {
    case nilValueForKey(String)
    case decodeError(Error)
    case remoteConfigFetchError(Error)
    case unknownError
}

extension FirebaseServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nilValueForKey(let key):
            return "Config value for key \(key) is not available."
        case .decodeError(let error):
            return "Failed to decode Photo from JSON: \(error.localizedDescription)"
        case .remoteConfigFetchError(let error):
            return "RemoteConfig fetch failed: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
}
