//
//  HomeView.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: Layout.padding(2)) {
                SearchView(search: viewStore.binding(\.$searchText))
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: Layout.padding(2.5)) {
                        if viewStore.viewState == .loading || viewStore.viewState == .idle {
                            skeleton
                        } else {
                            seriesList
                        }
                    }
                }
                .navigationDestination(
                    store: self.store.scope(
                        state: \.$serieDetail,
                        action: { .serieDetailsDispatch($0) }
                    ),
                    destination: { store in
                        SerieDetailsView(store: store)
                    })
            }
            .onFirstAppear { viewStore.send(.fetchSeries) }
            .padding(.horizontal, Layout.padding(2))
            .navigationTitle("Home")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.vertical))
        }
    }
    
    var skeleton: some View {
        WithViewStore(store) { viewStore in
            ForEach(0..<4) { _ in
                SeriesCard(serie: .mock)
            }
            .redacted(reason: viewStore.viewState == .loading ? .placeholder : .init())
        }
    }
    
    var seriesList: some View {
        WithViewStore(store) { viewStore  in
            ForEach(viewStore.series) { serie in
                Button(action: { viewStore.send(.openSerie(serie.id, serie.image?.original ?? "")) }) {
                    SeriesCard(serie: serie)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView(store: Store(
                initialState: Home.State(),
                reducer: Home()
            ))
            .navigationBarHidden(true)
        }
    }
}
