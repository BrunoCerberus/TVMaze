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

extension Series {
    static var mock: Self {
        Self(
            id: 1,
            url: "https://www.tvmaze.com/shows/1/under-the-dome",
            name: "Under the Dome",
            language: "English",
            genres: ["Drama", "Science-Fiction", "Thriller"],
            rating: Rating(average: 3.5),
            image: ImageType(
                medium: "https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg",
                original: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg"
            ),
            summary: """
            Frank Martin returns as the Transporter with one very simple task - to deliver the package against all the odds./n
            However, something that sounds so simple, is rarely so.</p><p>Joined by two new team members, Caterina Boldieu,/n
            an ex- DGSE agent and later in the series, Jules Faroux, a computer and mechanical whizz, Frank is hired to/n
            deliver a diverse range of packages - from pop princesses to priceless paintings.</p><p>Frank Martin takes the/n
            jobs no other transporter will touch or can achieve - simply because they are too challenging and the odds/n
            seemingly insurmountable. That is why he is considered the best transporter in the world.</p><p>Frank\'s jobs/n
            take him to many beautiful locations around the world, but they also draw him into danger and mystery. And more/n
            often than not, solving that mystery will lead Frank to successfully completing his mission.</p><p>However/n
            Frank\'s jobs aren\'t solely about the packages he must deliver but also about the people he meets. While his/n
            emphasis is always on completing the mission, Frank is unable to avoid the human emotions that come with dealing/n
            with clients in difficult situations - no matter how hard he tries.
            """
        )
    }
}
