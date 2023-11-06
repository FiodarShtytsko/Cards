//
//  CardFBModel.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

struct CardFBModel: Decodable {
    let url: URL
    let priority: Int
    
    
    enum CodingKeys: String, CodingKey {
        case url = "image_url"
        case priority
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(URL.self, forKey: .url)
        self.priority = try container.decode(Int.self, forKey: .priority)
    }
}
