//
//  CardFBModel.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

struct CardFBModel: Decodable {
    let id: Int
    let url: URL
    let name: String
    let priority: Int
    
    
    enum CodingKeys: String, CodingKey {
        case id 
        case name
        case url = "image_url"
        case priority
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(URL.self, forKey: .url)
        self.priority = try container.decode(Int.self, forKey: .priority)
    }
}
