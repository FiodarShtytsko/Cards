//
//  ImageDownloaderService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import UIKit

protocol ImageApi {
    func downloadImages(from urls: [( id: Int, url: URL)]) async throws -> [( id: Int, image: UIImage)]
}

final class ImageService: ImageApi {
    
    func downloadImages(from urls: [( id: Int, url: URL)]) async throws -> [( id: Int, image: UIImage)] {
        return try await withThrowingTaskGroup(of: (Int, UIImage)?.self) { group in
            for (id, url) in urls {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    return try await self.downloadImage(from: url, with: id)
                }
            }
            var imagesWithID = [( id: Int, image: UIImage)]()
            for try await image in group {
                if let image = image {
                    imagesWithID.append(image)
                }
            }
            return imagesWithID
        }
    }
    
    private func downloadImage(from url: URL, with id: Int) async throws -> (id: Int, image: UIImage) {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try response.validate()
        
        guard let image = UIImage(data: data) else {
            throw ImageServiceError.imageDecodingError
        }
        return (id, image)
    }
}
