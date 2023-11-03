//
//  ImageDownloaderService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import UIKit

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

final class ImageDownloaderService {
    
    func downloadImages(from urls: [URL]) async throws -> [UIImage] {
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            for url in urls {
                group.addTask { [weak self] in
                    guard let self = self else { return UIImage() }
                    return try await self.downloadImage(from: url)
                }
            }
            var images = [UIImage]()
            for try await image in group {
                images.append(image)
            }
            return images
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try response.validate()
        
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.imageDecodingError
        }
        return image
    }
}
