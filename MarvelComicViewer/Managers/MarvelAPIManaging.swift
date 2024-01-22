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

protocol MarvelAPIManaging {
    var keys: MarvelAPIKeys { get set }
    
    func fetchComic(id: Int) async throws -> FetchComicResponse
}

enum MarvelAPIMangingError: Error {
    case requestCreationFailed(Int)
}

class MarvelAPIManager: MarvelAPIManaging {
    
    private enum URLs {
        static let baseURL: String = "https://gateway.marvel.com/v1/public/comics/"
    }
    
    var keys: MarvelAPIKeys
    
    let networkManager: NetworkManaging
    
    init(keys: MarvelAPIKeys, networkManager: NetworkManaging) {
        self.keys = keys
        self.networkManager = networkManager
    }
    
    func fetchComic(id: Int) async throws -> FetchComicResponse {
        guard let request = createFetchComicRequest(id) else {
            throw MarvelAPIMangingError.requestCreationFailed(id)
        }
        
        let response: FetchComicResponse = try await networkManager.performRequest(request: request)
        
        return response
    }
    
    private func createFetchComicRequest(_ id: Int) -> URLRequest? {
        guard var url = URL(string: "\(URLs.baseURL)\(id)") else { return nil }
        
        url.decorateURL(keys: keys, date: Date())
        
        var request = URLRequest(url: url)
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
    mutating func decorateURL(keys: MarvelAPIKeys, date: Date) {
        let timestamp = "\(date.timeIntervalSince1970)"
        
        guard let hashData = (timestamp + keys.privateKey + keys.publicKey).data(using: .utf8) else { return }
        
        append(queryItems: [
            URLQueryItem(name: "apikey", value: keys.publicKey),
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hashData.md5())
        ])
    }
}
