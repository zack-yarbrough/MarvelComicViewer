//
//  ComicViewModel.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import Foundation

@Observable class ComicViewModel {
    var comic: Comic?
    var attributionText: String?
    
    let apiManager: MarvelAPIManaging
    
    var formattedDate: String? {
        comic?.publishedDate?.formatted(date: .abbreviated, time: .omitted)
    }
    
    init(
        apiManager: MarvelAPIManaging,
        comic: Comic? = nil,
        attributionText: String? = nil
    ) {
        self.apiManager = apiManager
        self.comic = comic
        self.attributionText = attributionText
    }
    
    func fetchComic(id: Int) {
        Task {
            do {
                let response: FetchComicResponse = try await apiManager.fetchComic(id: id)
                
                if let comic = response.data.results.first {
                    self.comic = comic
                    self.attributionText = response.attributionText
                }
            } catch (let error) {
                print(error)
                // handle error
            }
        }
    }
}
