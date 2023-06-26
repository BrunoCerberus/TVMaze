//
//  EpisodeDetailsView.swift
//  TVMaze
//
//  Created by bruno on 26/06/23.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {
    let store: StoreOf<EpisodeDetails>
    var body: some View {
        WithViewStore(store, observe: \.episode) { episode in
            VStack(spacing: Layout.padding(1)) {
                HStack(spacing: Layout.padding(2)) {
                    CacheImageView(url: episode.image?.original ?? "")
                        .scaledToFit()
                        .frame(width: 160, height: 180)
                    
                    VStack(alignment: .leading) {
                        Text(episode.name)
                            .font(.primary(.large2, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Rating: \(episode.rating.average ?? 0)")
                            .font(.primary(.medium2, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Release: \(episode.airdate?.toString(with: .dayMonthDate) ?? "") \(episode.airTime ?? "")")
                            .font(.primary(.medium2, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Episode: \(episode.number ?? 0)")
                            .font(.primary(.medium2, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Spacer(minLength: 1)
                }
                .padding(.horizontal, Layout.padding(1))
                
                Text(episode.summary)
                    .font(.secondary(.medium))
                    .foregroundColor(.text1)
                Spacer(minLength: 1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.vertical))
        }
    }
}

struct EpisodeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailsView(store: Store(
            initialState: EpisodeDetails.State(episode: EpisodesDetails(
                id: 1,
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
            )),
            reducer: EpisodeDetails()
        ))
    }
}
