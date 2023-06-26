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
    let season, number: Int
    let runtime: Int
    let rating: Rating
    let image: ImageType
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case season, number
        case runtime
        case rating
        case image
        case summary
    }
}
