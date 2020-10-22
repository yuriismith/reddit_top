//
//  RedditError.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

enum RedditError: Error {
    case badURL
    case invalidResponse
    case badRequest
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "URL is incorrect"
        case .invalidResponse:
            return "Response is Invalid"
        case .badRequest:
            return "Bad Request"
        default:
            return "Something went wrong..."
        }
    }
}
