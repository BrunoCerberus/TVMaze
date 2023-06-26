//
//  SeasonsDetails.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

typealias SeasonsDetailsResponse = [SeasonsDetails]

struct SeasonsDetails: BaseCodable, Equatable, Identifiable {
    let id: Int
    let url: String
    let number: Int
    let name: String
    let episodeOrder: Int
    let premiereDate, endDate: Date
    let image: ImageType
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case number
        case name
        case episodeOrder
        case premiereDate, endDate
        case image
        case summary
    }
}
