//
//  EpisodesDetailsResponse.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

typealias EpisodesDetailsResponse = [EpisodesDetails]

struct EpisodesDetails: BaseCodable, Equatable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let season: Int
    let number: Int?
    let airdate: String?
    let airTime: String?
    let runtime: Int
    let rating: Rating
    let image: ImageType?
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case season, number
        case airdate
        case airTime
        case runtime
        case rating
        case image
        case summary
    }
}

extension EpisodesDetails {
    static var mock: Self {
        Self(
            id: 1,
            url: "https://www.tvmaze.com/episodes/1/under-the-dome-1x01-pilot",
            name: "Pilot",
            season: 1,
            number: 1,
            airdate: "2023-06-26",
            airTime: "22:30",
            runtime: 60,
            rating: Rating(average: 3.5),
            image: ImageType(
                medium: "https://static.tvmaze.com/uploads/images/medium_landscape/1/4388.jpg",
                original: "https://static.tvmaze.com/uploads/images/original_untouched/1/4388.jpg"
            ),
            summary: "When the residents of Chester's Mill find themselves trapped under a massive transparent dome with no way out, they struggle to survive as resources rapidly dwindle and panic quickly escalates."
        )
    }
}
