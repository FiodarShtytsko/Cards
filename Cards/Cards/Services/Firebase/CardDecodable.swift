//
//  CardDecodable.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

protocol CardDecodable {
    func decodeCard(from data: Data) throws -> CardFBModel
}

struct CardDecoder: CardDecodable {
    func decodeCard(from data: Data) throws -> CardFBModel {
        return try JSONDecoder().decode(CardFBModel.self, from: data)
    }
}
