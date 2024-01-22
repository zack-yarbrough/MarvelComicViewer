//
//  MarvelAPIManagerTests.swift
//  MarvelAPIManagerTests
//
//  Created by Zack Yarbrough on 1/22/24.
//

import XCTest
@testable import MarvelComicViewer

final class MarvelAPIManagerTests: XCTestCase {
    
    var keys: MarvelAPIKeys!

    override func setUpWithError() throws {
        keys = MarvelAPIKeys(publicKey: "publicKey", privateKey: "privateKey")
    }
    
    // Tests to ensure comic ID is appended to request URL
    func test_createFetchComicRequest() throws {
        // given
        let manager = MarvelAPIManager(keys: keys)
        let id: Int = 12345
        
        // when
        let request = try XCTUnwrap(manager.createFetchComicRequest(id: id))
        
        // then
        XCTAssertEqual(request.url?.path(), "/v1/public/comics/12345")
    }
    
    func test_decorateURL() throws {
        // given
        var url = try XCTUnwrap(URL(string: "http://marvel.com"))
        let date = Date(timeIntervalSince1970: 100_000)
        
        let ts = "\(date.timeIntervalSince1970)"
        let hash = try XCTUnwrap((ts + keys.privateKey + keys.publicKey).data(using: .utf8))
        
        // when
        url.decorateURL(keys: keys, date: date)
        
        // then
        XCTAssertEqual(url.absoluteString, "http://marvel.com?apikey=\(keys.publicKey)&ts=\(ts)&hash=\(hash.md5())")
    }

}
