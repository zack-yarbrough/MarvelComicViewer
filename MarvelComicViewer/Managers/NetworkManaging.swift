//
//  NetworkManaging.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import Foundation

protocol NetworkManaging {
    func performRequest<T: Decodable>(request: URLRequest) async throws -> T
}

enum NetworkManagingError: Error {
    case parseFailed
}

class NetworkManager: NetworkManaging {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func performRequest<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, _) = try await urlSession.data(for: request)
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        
        return decodedData
    }
}
