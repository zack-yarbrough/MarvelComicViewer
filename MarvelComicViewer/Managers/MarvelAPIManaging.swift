//
//  MarvelAPIManager.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import CryptoKit
import Foundation

struct MarvelAPIKeys: Codable {
    let publicKey: String
    let privateKey: String
}

/// Instances of `MarvelAPIManaging` will be reponsible for handling any API-related functions with the external
/// Marvel API.
protocol MarvelAPIManaging {
    /// The set of API keys to use when querying the API.
    var keys: MarvelAPIKeys { get set }
    
    /// Fetches information about a comic.
    /// - Parameter id: The comic ID.
    /// - Returns: An instance of `FetchComicResponse` with information about the specific comic.
    func fetchComic(id: Int) async throws -> FetchComicResponse
}

enum MarvelAPIMangingError: Error {
    /// An error thrown when the API request creation has failed for any reason.
    case requestCreationFailed
    
    /// An error thrown when
    case unsuccessfulResponse
}

class MarvelAPIManager: MarvelAPIManaging {
    
    private enum URLs {
        static let baseURL: String = "https://gateway.marvel.com/v1/public/comics/"
    }
    
    var keys: MarvelAPIKeys
    
    let networkManager: NetworkManaging
    
    init(
        keys: MarvelAPIKeys,
        networkManager: NetworkManaging
    ) {
        self.keys = keys
        self.networkManager = networkManager
    }
    
    func fetchComic(id: Int) async throws -> FetchComicResponse {
        guard let url = URL(string: "\(URLs.baseURL)\(id)"),
              let request = createRequest(url) else {
            throw MarvelAPIMangingError.requestCreationFailed
        }
        
        let result: Result<FetchComicResponse, Error> = try await networkManager.performRequest(request: request)

        guard case let .success(comicResponse) = result else {
            throw MarvelAPIMangingError.unsuccessfulResponse
        }

        return comicResponse
    }
    
    internal func createRequest(_ url: URL) -> URLRequest? {
        guard let decoratedURL = url.decorateURL(keys: keys, date: Date()) else { return nil }
        
        var request = URLRequest(url: decoratedURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}

extension Data {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: self)
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

extension URL {
    /// A helper function that decorates existing URLs with required params for the API.
    /// - Returns: A decorated URL.
    func decorateURL(keys: MarvelAPIKeys, date: Date) -> URL? {
        let timestamp = "\(date.timeIntervalSince1970)"
        
        guard let hashData = (timestamp + keys.privateKey + keys.publicKey).data(using: .utf8) else { return nil }
        
        var decoratedURL = self
        decoratedURL.append(queryItems: [
            URLQueryItem(name: "apikey", value: keys.publicKey),
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hashData.md5())
        ])
        
        return decoratedURL
    }
}
