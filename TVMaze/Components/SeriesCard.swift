//
//  SeriesCard.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import SwiftUI

struct SeriesCard: View {
    private struct Constants {
        static let height: Double = 273
    }
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: Layout.padding(2)) {
                CacheImageView(url: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg")
                    .cornerRadius(Layout.padding(1))
                    .scaledToFit()
                    .frame(width: (geo.size.width / 2) - 8)
                VStack(alignment: .leading, spacing: Layout.padding(1.2)) {
                    Text("Hitman’s Wife’s Bodyguard")
                        .lineLimit(2)
                        .font(.primary(.largeMedium, weight: .bold))
                        .foregroundColor(.white)
                    HStack {
                        Text("Rating:")
                            .font(.primary(.largeMedium, weight: .regular))
                            .foregroundColor(.white)
                        Text("3.5")
                            .font(.secondary(.largeMedium))
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: Layout.padding(0.4)) {
                        ForEach(0..<3) { _ in
                            Text("Action")
                                .lineLimit(1)
                                .font(.primary(.medium))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("The world's most lethal odd couple - bodyguard Michael Bryce and hitman Darius Kincaid - are back on anoth......")
                        .lineLimit(5)
                        .font(.secondary(.small3))
                        .foregroundColor(.text1)
                    
                    Spacer(minLength: 1)
                }
                .padding(.top, Layout.padding(2))
                .frame(width: (geo.size.width / 2) - 8)
            }
        }
        .frame(height: Constants.height)
    }
}

struct SeriesCard_Previews: PreviewProvider {
    static var previews: some View {
        SeriesCard()
            .previewLayout(.fixed(width: 379.00, height: 273.00))
            .preferredColorScheme(.dark)
    }
}
