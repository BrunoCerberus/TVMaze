//
//  SeriesResponse.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

typealias SeriesResponse = [Series]

struct Series: BaseCodable, Equatable, Identifiable {
    let id: Int
    let url: String
    let name: String
    let language: String
    let genres: [String]
    let rating: Rating
    let image: ImageType?
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case language
        case genres
        case rating
        case image
        case summary
    }
}

struct Rating: BaseCodable, Equatable {
    let average: Double?
    
    enum CodingKeys: String, CodingKey {
        case average
    }
}

struct ImageType: BaseCodable, Equatable {
    let medium, original: String
}
