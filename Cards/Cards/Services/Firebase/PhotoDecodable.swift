//
//  PhotoDecodable.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

protocol PhotoDecodable {
    func decodePhoto(from data: Data) throws -> Photo
}

struct PhotoDecoder: PhotoDecodable {
    func decodePhoto(from data: Data) throws -> Photo {
        return try JSONDecoder().decode(Photo.self, from: data)
    }
}
