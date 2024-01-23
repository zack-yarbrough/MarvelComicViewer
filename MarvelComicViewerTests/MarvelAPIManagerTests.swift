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
    
    func test_decorateURL() throws {
        // given
        let url = try XCTUnwrap(URL(string: "http://marvel.com"))
        let date = Date(timeIntervalSince1970: 100_000)
        
        let ts = "\(date.timeIntervalSince1970)"
        let hash = try XCTUnwrap((ts + keys.privateKey + keys.publicKey).data(using: .utf8))
        
        // when
        let decoratedURL = url.decorateURL(keys: keys, date: date)
        
        // then
        XCTAssertEqual(decoratedURL?.absoluteString, "http://marvel.com?apikey=\(keys.publicKey)&ts=\(ts)&hash=\(hash.md5())")
    }

}
