//
//  ImageServiceError.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

enum ImageServiceError: LocalizedError {
    case imageDecodingError
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .imageDecodingError:
            return "Failed to decode the image."
        case .networkError:
            return "Failed to download the image or retrieve data."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
