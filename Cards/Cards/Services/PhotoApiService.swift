//
//  PhotoApiService.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 02/11/2023.
//

import Foundation

final class PhotoApiService {
    
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    
    func fetchPhotos() async throws -> [Photo] {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        try response.validate()
        return try JSONDecoder().decode([Photo].self, from: data)
    }
}
