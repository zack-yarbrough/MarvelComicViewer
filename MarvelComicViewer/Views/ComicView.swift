//
//  ComicView.swift
//  MarvelComicViewer
//
//  Created by Zack Yarbrough on 1/22/24.
//

import SwiftUI

struct ComicView: View {
    
    @State var viewModel: ComicViewModel
    
    init(viewModel: ComicViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            if let comic = viewModel.comic {
                VStack {
                    VStack(spacing: 15.0) {
                        AsyncImage(url: comic.thumnailURL)
                            .frame(width: 150, height: 225, alignment: .leading)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(2.0)
                        
                        Text(comic.title)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .accessibilityIdentifier("Comic.Title")
                    }
                    .padding(.bottom, 25.0)
                    
                    if let description = comic.description {
                        Text(description)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityIdentifier("Comic.Description")
                    }
                    
                    VStack(spacing: 5.0) {
                        if let series = comic.series {
                            Divider()
                                .padding(.vertical, 15.0)
                            
                            Text("**\(NSLocalizedString("Series", comment: "")):** \(series.name)")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityIdentifier("Comic.Series")
                        }
                        
                        if let publishedDate = viewModel.formattedDate {
                            Text("**\(NSLocalizedString("Published", comment: "")):** \(publishedDate)")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .accessibilityIdentifier("Comic.Date")
                        }
                    }
                    
                    if let creatorList = comic.creatorList {
                        Divider()
                            .padding(.vertical, 15.0)
                        
                        VStack(alignment: .leading, spacing: 5.0) {
                            ForEach(creatorList.creators, id: \.self) { creator in
                                Text("**\(creator.role.localizedCapitalized):** \(creator.name.localizedCapitalized)")
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .accessibilityIdentifier("Comic.Creator")
                            }
                        }
                    }
                    
                    if let attributionText = viewModel.attributionText {
                        Divider()
                            .padding(.vertical, 15.0)
                        
                        Text(attributionText)
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityIdentifier("Comic.Attribution")
                    }
                    
                    Spacer()
                }
                .padding(.all, 15.0)
            }
        }
        .onAppear {
            viewModel.fetchComic(id: 112364)
        }
    }
}

#Preview {
    ComicView(viewModel: ComicViewModel(
        apiManager: MarvelAPIManager(
            keys: MarvelAPIKeys(publicKey: "", privateKey: ""),
            networkManager: NetworkManager(urlSession: URLSession.shared)
        ),
        comic: Comic(
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
            creatorList: ComicCreatorList(creators: [
                ComicCreator(name: "Creator #1", role: "Role #1"),
                ComicCreator(name: "Creator #2", role: "Role #2"),
                ComicCreator(name: "Creator #3", role: "Role #3"),
            ])
        ),
        attributionText: "Data provided by Marvel. © 2024 MARVEL"
    ))
}
