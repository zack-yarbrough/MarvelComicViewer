//
//  FetchComicResponse.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import Foundation

struct FetchComicResponse: Codable {
    let attributionText: String?
    let data: ComicDataContainer
}

struct ComicDataContainer: Codable {
    let results: [Comic]
}
