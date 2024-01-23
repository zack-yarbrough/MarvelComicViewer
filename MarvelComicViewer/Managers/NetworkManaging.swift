//
//  NetworkManaging.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import Foundation

/// Instances of `NetworkingManaging` will be repsonsible for handling network requests and parsing responses, if applicable.
protocol NetworkManaging {
    /// Performs the given request and decodes the response.
    /// - Parameter request: The request to perform.
    /// - Returns: The decoded data.
    func performRequest<T: Decodable>(request: URLRequest) async throws -> Result<T, Error>
}

enum NetworkManagingError: Equatable, Error {
    /// Indicates that parsing has failed.
    case parseFailed
    
    /// Indicates that networking has failed.
    case networkingFailed
}

class NetworkManager: NetworkManaging {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func performRequest<T: Decodable>(
        request: URLRequest
    ) async throws -> Result<T, Error> {
        let (data, response) = try await urlSession.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            return .failure(NetworkManagingError.networkingFailed)
        }
        
        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(NetworkManagingError.parseFailed)
        }
        
        return .success(object)
    }
}
