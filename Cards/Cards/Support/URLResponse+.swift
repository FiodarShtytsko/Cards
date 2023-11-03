//
//  URLResponse+.swift
//  Cards
//
//  Created by Fiodar Shtytsko on 03/11/2023.
//

import Foundation

extension URLResponse {
    func validate() throws {
        if let httpResponse = self as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw ImageServiceError.networkError
        }
    }
}
