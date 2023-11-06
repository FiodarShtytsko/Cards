//
//  ImageDownloaderService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import UIKit

protocol ImageApi {
    func downloadImages(from urls: [URL]) async throws -> [UIImage]
}

final class ImageService: ImageApi {
    
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
