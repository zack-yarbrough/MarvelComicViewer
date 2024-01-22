//
//  ComicTests.swift
//  ComicTests
//
//  Created by Zack Yarbrough on 1/22/24.
//

import XCTest
@testable import MarvelComicViewer

final class ComicTests: XCTestCase {

    static let comic: Comic = Comic(
        id: 1,
        title: "Test comic title",
        description: "Test comic description",
        thumbnail: ComicImage(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73",
            pathExtension: "jpg"
        ),
        dates: [
            ComicDate(type: "onsaleDate", date: Date())
        ],
        series: ComicSeries(name: "Test series title"),
        creatorList: nil
    )
    
    func test_thumbnailURL() {
        // when
        let thumbnailURL = ComicTests.comic.thumnailURL
        
        // then
        XCTAssertEqual(
            thumbnailURL?.absoluteString,
            "http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73/portrait_xlarge.jpg"
        )
    }
    
    func test_publishedDate() {
        // given
        let date = Date()
        let comic = Comic(
            id: 1,
            title: "Test comic title",
            description: "Test comic description",
            thumbnail: ComicImage(
                path: "http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73",
                pathExtension: "jpg"
            ),
            dates: [
                ComicDate(type: "onsaleDate", date: date)
            ],
            series: ComicSeries(name: "Test series title"),
            creatorList: nil
        )
        
        // when
        let publishedDate = comic.publishedDate
        
        // then
        XCTAssertEqual(publishedDate, date)
    }
    
    func test_publishedDate_noPublishedDate() {
        // given
        let date = Date()
        let comic = Comic(
            id: 1,
            title: "Test comic title",
            description: "Test comic description",
            thumbnail: ComicImage(
                path: "http://i.annihil.us/u/prod/marvel/i/mg/3/40/4bb4680432f73",
                pathExtension: "jpg"
            ),
            dates: [
                ComicDate(type: "focDate", date: date)
            ],
            series: ComicSeries(name: "Test series title"),
            creatorList: nil
        )
        
        // when
        let publishedDate = comic.publishedDate
        
        // then
        XCTAssertNil(publishedDate)
    }
}
