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
        static let nftHeaderRatio: CGFloat = 1.2
    }
    let gradient: Gradient = Gradient(
        stops: [
            Gradient.Stop(color: .background.opacity(0), location: 0),
            Gradient.Stop(color: .background.opacity(0.1), location: 0.2),
            Gradient.Stop(color: .background.opacity(0.60), location: 0.85),
            Gradient.Stop(color: .background, location: 1)
        ]
    )
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: Layout.padding(2)) {
                ScrollView(showsIndicators: false) {
                    stickyHeader
                }
            }
            .onAppear { viewStore.send(.fetchSeasons) }
            .navigationTitle("Serie")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.vertical))
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
                                .frame(width: geometry.size.width, height: geometry.size.width * Constants.nftHeaderRatio)
                                .offset(y: geometry.frame(in: .global).minY / 9)
                                .clipped()
                        } else {
                            CacheImageView(url: viewStore.posterImageURL)
                                .scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.width * Constants.nftHeaderRatio + geometry.frame(in: .global).minY)
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
                    
                    Text("Serie")
                        .font(.primary(.large21))
                        .foregroundColor(.white)
                        .padding(.top, (geometry.size.width * Constants.nftHeaderRatio) - 60)
                        .padding(.leading, 24)
                }
            }
        }
    }
}

struct SerieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SerieDetailsView(store: Store(
            initialState: SerieDetails.State(
                posterImageURL: "https://static.tvmaze.com/uploads/images/original_untouched/163/407679.jpg"
            ),
            reducer: SerieDetails()
        ))
    }
}
