//
//  NetworkManager.swift
//  Reddit Top
//
//  Created by Yurii Koval on 10/22/20.
//  Copyright © 2020 Yurii Koval. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // MARK: - Service logic
    
    static private func fetchResources<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, RedditError>) -> Void) {
        
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { response in
            switch response {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                DummyErrorHandler.handle(error)
            case .success(let (response, data)):
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, !(200..<299 ~= statusCode) {
                    DummyErrorHandler.handle(RedditError.invalidResponse)
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
                    }
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(.decodingError))
                        DummyErrorHandler.presentDefaultError()
                    }
                }
            }
        }.resume()
    }
    
    static private func prepareRequest(for endpoint: Endpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "reddit.com"
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        return request
    }
    
    // MARK: - Endpoints logic
    
    static func getTop(limit: Int, completion: @escaping (Result<[Entry], RedditError>) -> Void) {
        getTopInternal(limit: limit) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data.children.entries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func getTopInternal(limit: Int, completion: @escaping (Result<Welcome, RedditError>) -> Void) {
        guard let request = prepareRequest(for: Endpoint.top(limit: limit)) else { return }
        fetchResources(request: request, completion: completion)
    }
    
}

extension URLSession {
    
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionTask {
        return dataTask(with: request) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
}
