//
//  MarvelComicViewerApp.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import SwiftUI

@main
struct MarvelComicViewerApp: App {
    var comicViewModel: ComicViewModel = {
        let apiManager = MarvelAPIManager(
            keys: fetchAPIKeys(),
            networkManager: NetworkManager(urlSession: URLSession.shared)
        )
        return ComicViewModel(apiManager: apiManager)
    }()
    
    var body: some Scene {
        WindowGroup {
            ComicView(viewModel: comicViewModel)
                .onAppear {
                    URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
                    URLCache.shared.diskCapacity = 100_000_000 // ~100MB disk cache space
                }
        }
    }
    
    private static func fetchAPIKeys() -> MarvelAPIKeys {
        let decoder = PropertyListDecoder()
        
        guard let path = Bundle.main.url(forResource: "keys", withExtension: "plist"),
              let data = try? Data(contentsOf: path),
              let keys = try? decoder.decode(MarvelAPIKeys.self, from: data) else {
            fatalError("Could not retrieve keys from keys.plist")
        }
        
        return keys
    }
}
