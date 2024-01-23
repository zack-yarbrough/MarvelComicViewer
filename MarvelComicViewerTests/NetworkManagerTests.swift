//
//  NetworkManagerTests.swift
//  MarvelComicViewerTests
//
//  Created by Zack Yarbrough on 1/23/24.
//

import XCTest
@testable import MarvelComicViewer

final class NetworkManagerTests: XCTestCase {
    
    var urlSession: URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }

    func test_unsuccessfulStatusCode() async throws {
        // given
        let mockURL = try XCTUnwrap(URL(string: "http://marvel.com"))
        let networkManager = NetworkManager(urlSession: urlSession)
        
        let request = URLRequest(url: mockURL)
        
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: mockURL,
                statusCode: 404,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            ))
            return (response, Data())
        }
        
        // when
        let result: Result<FetchComicResponse, Error> = try await networkManager.performRequest(request: request)
        
        // then
        switch result {
        case .success(let success):
            XCTFail("Should not receive a successful result with a failing status code.")
        case .failure(let failure):
            XCTAssertEqual(failure as? NetworkManagingError, NetworkManagingError.networkingFailed)
        }
    }
    
    func test_unsuccessfulParsing() async throws {
        // given
        let mockURL = try XCTUnwrap(URL(string: "http://marvel.com"))
        let networkManager = NetworkManager(urlSession: urlSession)
        
        let response = """
        {
            "testKey": "testValue"
        }
        """
        let data = try XCTUnwrap(response.data(using: .utf8))
        let request = URLRequest(url: mockURL)
        
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: mockURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            ))
            return (response, data)
        }
        
        // when
        let result: Result<FetchComicResponse, Error> = try await networkManager.performRequest(request: request)
        
        // then
        switch result {
        case .success(let success):
            XCTFail("Should not receive a successful result with an incorrect JSON.")
        case .failure(let failure):
            XCTAssertEqual(failure as? NetworkManagingError, NetworkManagingError.parseFailed)
        }
    }

    func test_successfulParsing() async throws {
        // given
        let mockURL = try XCTUnwrap(URL(string: "http://marvel.com"))
        let networkManager = NetworkManager(urlSession: urlSession)
        
        let response = """
        {
          "attributionText": "test text",
          "data": {
            "results": [
              {
                "id": 112364,
                "title": "Test title",
                "description": "Test description",
                "series": {
                  "name": "Test series"
                },
                "thumbnail": {
                  "path": "testPath",
                  "extension": "testExtension"
                }
              }
            ]
          }
        }
        """
        let data = try XCTUnwrap(response.data(using: .utf8))
        let request = URLRequest(url: mockURL)
        
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: mockURL,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            ))
            return (response, data)
        }
        
        // when
        let result: Result<FetchComicResponse, Error> = try await networkManager.performRequest(request: request)
        
        // then
        switch result {
        case .success(let success):
            XCTAssertEqual(success.data.results.count, 1)
        case .failure(let failure):
            XCTFail("Should not receive a failing result with proper JSON.")
        }
    }
}

class MockURLProtocol: URLProtocol {
    static var error: Error?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // no-op
    }
}
