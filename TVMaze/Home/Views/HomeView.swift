//
//  HomeView.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: Layout.padding(2)) {
            SearchView(search: .constant(""))
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Layout.padding(2.5)) {
                    seriesList
                }
            }
        }
        .padding(.horizontal, Layout.padding(2))
        .navigationTitle("Home")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    var seriesList: some View {
        ForEach(0..<4) { _ in
            SeriesCard()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
