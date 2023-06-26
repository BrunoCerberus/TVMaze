//
//  SerieDetailsView.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI
import ComposableArchitecture

struct SerieDetailsView: View {
    let store: StoreOf<SerieDetails>
    
    @State private var pagePosition: CGFloat = 0

    private struct Constants {
        static let coverHeightRation: CGFloat = 1.3
    }
    let gradient: Gradient = Gradient(
        stops: [
            Gradient.Stop(color: .background.opacity(0), location: 0),
            Gradient.Stop(color: .background.opacity(0.4), location: 0.2),
            Gradient.Stop(color: .background.opacity(0.6), location: 0.5),
            Gradient.Stop(color: .background.opacity(0.90), location: 0.85),
            Gradient.Stop(color: .background, location: 1)
        ]
    )
    var body: some View {
        WithViewStore(store) { viewStore in
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Layout.padding(2)) {
                        stickyHeader
                        VStack(spacing: Layout.padding(1)) {
                            if viewStore.seasons.count > 0 {
                                Tabs(
                                    titles: viewStore.seasons.compactMap { "Season \($0.number)" },
                                    currentPage: viewStore.binding(\.$currentPage),
                                    currentPosition: $pagePosition,
                                    tabType: .scrollable
                                )
                                episodesListView
                            }
                        }
                        .padding(.top, geo.size.width * Constants.coverHeightRation - 32)
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear { viewStore.send(.fetchSeasons) }
            .navigationTitle("Serie")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.vertical))
            .sheet(
                store: store.scope(
                    state: \.$episodeDetail,
                    action: { .episodeDetailsDispatch($0) }),
                content: { store in
                    EpisodeDetailsView(store: store)
                }
            )
        }
    }
    
    var stickyHeader: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                GeometryReader { geometry in
                    VStack {
                        if geometry.frame(in: .global).minY <= 0 {
                            CacheImageView(url: viewStore.posterImageURL)
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width * Constants.coverHeightRation)
                                .offset(y: geometry.frame(in: .global).minY / 9)
                                .clipped()
                        } else {
                            CacheImageView(url: viewStore.posterImageURL)
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width * Constants.coverHeightRation + geometry.frame(in: .global).minY)
                                .clipped()
                                .offset(y: -geometry.frame(in: .global).minY)
                        }
                    }
                    .overlay(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    Text("Seasons")
                        .font(.primary(.large21))
                        .foregroundColor(.white)
                        .padding(.top, (geometry.size.width * Constants.coverHeightRation) - 60)
                        .padding(.leading, 24)
                }
            }
        }
    }
    
    var episodesListView: some View {
        WithViewStore(store) { viewStore in
            LazyVStack(spacing: Layout.padding(0)) {
                ForEach(viewStore.episodes) { episode in
                    Button(action: { viewStore.send(.openEpisode(episode)) }) {
                        EpisodeView(episode: episode)
                    }
                    Divider()
                        .frame(height: 1)
                        .foregroundColor(.lightGray)
                }
            }
        }
    }
}

struct SerieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SerieDetailsView(store: Store(
            initialState: SerieDetails.State(
                posterImageURL: "https://static.tvmaze.com/uploads/images/original_untouched/163/407679.jpg",
                seasons: [
                    SeasonsDetails(
                        id: 0,
                        url: "",
                        number: 1,
                        name: "",
                        episodeOrder: 1,
                        premiereDate: .now,
                        endDate: .now,
                        image: ImageType(medium: "", original: ""),
                        summary: ""
                    ),
                    SeasonsDetails(
                        id: 1,
                        url: "",
                        number: 2,
                        name: "",
                        episodeOrder: 2,
                        premiereDate: .now,
                        endDate: .now,
                        image: ImageType(medium: "", original: ""),
                        summary: ""
                    ),
                    SeasonsDetails(
                        id: 2,
                        url: "",
                        number: 2,
                        name: "",
                        episodeOrder: 3,
                        premiereDate: .now,
                        endDate: .now,
                        image: ImageType(medium: "", original: ""),
                        summary: ""
                    )
                ],
                episodes: [
                    EpisodesDetails(
                        id: 0,
                        url: "https://www.tvmaze.com/episodes/1/under-the-dome-1x01-pilot",
                        name: "Pilot",
                        season: 1,
                        number: 1,
                        airdate: .now,
                        airTime: "22:30",
                        runtime: 60,
                        rating: Rating(average: 3.5),
                        image: ImageType(
                            medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                            original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"
                        ),
                        summary: "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates."
                    ),
                    EpisodesDetails(
                        id: 1,
                        url: "https://www.tvmaze.com/episodes/1/under-the-dome-1x01-pilot",
                        name: "Pilot",
                        season: 1,
                        number: 2,
                        airdate: .now,
                        airTime: "22:30",
                        runtime: 60,
                        rating: Rating(average: 3.5),
                        image: ImageType(
                            medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                            original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"
                        ),
                        summary: "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates."
                    )
                ]
            ),
            reducer: SerieDetails()
        ))
    }
}
