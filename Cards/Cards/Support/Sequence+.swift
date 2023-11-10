//
//  Sequence+.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 06/11/2023.
//

import Foundation

extension Sequence {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async throws -> [T] {
        var results = [T]()
        for element in self {
            results.append(try await transform(element))
        }
        return results
    }
}
