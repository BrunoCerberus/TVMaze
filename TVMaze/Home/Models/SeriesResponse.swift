//
//  SeriesResponse.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

typealias SeriesResponse = [Series]

struct Series: BaseCodable {
    let id: Int
    let url: String
    let name: String
    let language: String
    let genres: [String]
    let rating: Rating
    
    init(
        id: Int,
        url: String,
        name: String,
        language: String,
        genres: [String],
        rating: Rating
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.language = language
        self.genres = genres
        self.rating = rating
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case language
        case genres
        case rating
    }
}

struct Rating: BaseCodable {
    let average: Double?
    
    init(average: Double?) {
        self.average = average
    }
    
    enum CodingKeys: String, CodingKey {
        case average
    }
}
