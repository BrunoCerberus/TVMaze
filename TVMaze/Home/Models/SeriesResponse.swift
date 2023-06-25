//
//  SeriesResponse.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

typealias SeriesResponse = [Series]

struct Series: BaseCodable, Equatable {
    let id: Int
    let url: String
    let name: String
    let language: String
    let genres: [String]
    let rating: Rating
    let image: ImageType
    let summary: String
    
    init(
        id: Int,
        url: String,
        name: String,
        language: String,
        genres: [String],
        rating: Rating,
        image: ImageType,
        summary: String
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.language = language
        self.genres = genres
        self.rating = rating
        self.image = image
        self.summary = summary
    }
    
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
    
    init(average: Double?) {
        self.average = average
    }
    
    enum CodingKeys: String, CodingKey {
        case average
    }
}

struct ImageType: BaseCodable, Equatable {
    let medium, original: String
}
