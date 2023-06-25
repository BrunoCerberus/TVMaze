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
                    VStack(alignment: .leading, spacing: Layout.padding(2.5)) {
                        seriesList
                    }
                }
            }
            .padding(.horizontal, Layout.padding(2))
            .navigationTitle("Home")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background.edgesIgnoringSafeArea(.all))
        }
    }
    
    var seriesList: some View {
        ForEach(0..<4) { _ in
            SeriesCard()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(
            initialState: Home.State(),
            reducer: Home()
        ))
    }
}
