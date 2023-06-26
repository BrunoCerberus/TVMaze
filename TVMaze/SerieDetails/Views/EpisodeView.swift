//
//  EpisodeView.swift
//  TVMaze
//
//  Created by bruno on 26/06/23.
//

import SwiftUI

struct EpisodeView: View {
    private(set) var episode: EpisodesDetails
    private struct Constants {
        static let height: Double = 140
    }
    var body: some View {
        HStack(spacing: Layout.padding(2)) {
            CacheImageView(url: episode.image?.medium ?? "")
                .scaledToFit()
                .frame(width: 170.0, height: 100.0)
            VStack(alignment: .leading, spacing: Layout.padding(0.6)) {
                Text(episode.name)
                    .lineLimit(2)
                    .font(.primary(.largeMedium, weight: .bold))
                    .foregroundColor(.white)
                Text("Episode: \(episode.number ?? 0)")
                    .lineLimit(1)
                    .font(.primary(.small3, weight: .regular))
                    .foregroundColor(.white)
                HStack(alignment: .center, spacing: Layout.padding(0.4)) {
                    Text("Duration:")
                        .font(.primary(.small3, weight: .regular))
                        .foregroundColor(.white)
                    Text("\(episode.runtime)m")
                        .font(.secondary(.small3))
                        .foregroundColor(.white)
                }
                
                Text(episode.summary)
                    .lineLimit(5)
                    .font(.secondary(.small3))
                    .foregroundColor(.text1)
                
                Spacer(minLength: 1)
            }
            .padding(.top, Layout.padding(2))
        }
        .multilineTextAlignment(.leading)
        .frame(height: Constants.height)
        .frame(maxWidth: .infinity)
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(episode: EpisodesDetails(
            id: 1,
            url: "https://www.tvmaze.com/episodes/1/under-the-dome-1x01-pilot",
            name: "Pilot",
            season: 1,
            number: 1,
            runtime: 60,
            rating: Rating(average: 3.5),
            image: ImageType(
                medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"
            ),
            summary: "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates."
        ))
        .previewLayout(.fixed(width: 379.00, height: 140.00))
        .preferredColorScheme(.dark)
    }
}
