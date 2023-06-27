//
//  SearchView.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI

struct SearchView: View {
    
    private struct Constants {
        static let height = 50.0
        static let magnifyingGlassWidth = 24.0
        static let magnifyingGlassHeight = 24.0
    }
    
    @Binding var search: String
    
    var body: some View {
        HStack(spacing: Layout.padding(2)) {
            Image.magnifyingGlass
                .resizable()
                .scaledToFit()
                .frame(width: Constants.magnifyingGlassWidth, height: Constants.magnifyingGlassHeight)
            TextField("Search", text: $search)
                .font(.primary(.large))
                .foregroundColor(.white20)
            Spacer(minLength: 1)
        }
        .padding(.horizontal, Layout.padding(2))
        .padding(.vertical, Layout.padding(3))
        .frame(height: Constants.height)
        .background(Color.darkGray)
        .cornerRadius(Layout.padding(0.5))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(search: .constant(""))
            .previewLayout(.fixed(width: 379.09, height: 80.00))
            .preferredColorScheme(.dark)
    }
}
