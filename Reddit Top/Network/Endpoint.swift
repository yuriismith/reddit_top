//
//  Endpoint.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

enum Endpoint {
    
//    https://www.reddit.com/top.json?limit=2&after=t3_jfekup
    
    //yes, it can be one method and one endpoint, but we need to show multiple endpoints somehow ;)
    
    case top(limit: Int)
    case page(limit: Int, lastId: String)
    
    var method: Method {
        switch self {
        case .top(_):
            return .GET
        case .page(_, _):
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .top(_):
            return "/top.json"
        case .page(_, _):
            return "/top.json"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .top(let limit):
            return [URLQueryItem(name: "limit", value: String(limit))]
        case .page(let limit, let lastId):
            return [ URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "after", value: lastId)]
        }
    }
}

enum Method: String {
    case GET = "GET"
    case POST = "POST"
}
