//
//  Comic.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import Foundation

struct Comic: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: ComicImage?
    let dates: [ComicDate]?
    let series: ComicSeries?
    let creatorList: ComicCreatorList?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnail
        case dates
        case series
        case creatorList = "creators"
    }
}

extension Comic {
    var thumnailURL: URL? {
        guard let thumbnail else { return nil }
        
        return URL(string: "\(thumbnail.path)/portrait_xlarge.\(thumbnail.pathExtension)")
    }
    
    var publishedDate: Date? {
        dates?.first(where: { $0.isPublishedDate })?.date
    }
}

struct ComicImage: Codable {
    let path: String
    let pathExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case pathExtension = "extension"
    }
}

struct ComicSeries: Codable {
    let name: String
}

struct ComicDate: Codable {
    let type: String
    let date: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        
        let dateFormatter = ISO8601DateFormatter()
        guard let dateString = try container.decodeIfPresent(String.self, forKey: .date),
              let date = dateFormatter.date(from: dateString) else { throw NetworkManagingError.parseFailed }
        self.date = date
    }
    
    init(type: String, date: Date) {
        self.type = type
        self.date = date
    }
    
    var isPublishedDate: Bool {
        type == "onsaleDate"
    }
}

struct ComicCreatorList: Codable {
    let creators: [ComicCreator]
    
    enum CodingKeys: String, CodingKey {
        case creators = "items"
    }
}

struct ComicCreator: Codable, Hashable {
    let name: String
    let role: String
}
