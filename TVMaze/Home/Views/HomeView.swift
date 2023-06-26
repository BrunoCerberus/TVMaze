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
                        seriesList
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
            .onAppear { viewStore.send(.fetchSeries) }
            .padding(.horizontal, Layout.padding(2))
            .navigationTitle("Home")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.vertical))
        }
    }
    
    var seriesList: some View {
        WithViewStore(store) { viewStore  in
            ForEach(viewStore.series) { serie in
                SeriesCard(serie: serie)
                    .onTapGesture {
                        viewStore.send(.openSerie(serie.id, serie.image?.original ?? ""))
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
