//
//  SerieDetailsAPI.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import Foundation

enum SeasonsDetailsAPI {
    case fetchSeasons(Int)
    case fetchEpisodes(Int)
}

extension SeasonsDetailsAPI: Fetcher {
    var path: String {
        switch self {
        case let .fetchSeasons(id):
            return "https://api.tvmaze.com/shows/\(id)/seasons"
        case let .fetchEpisodes(id):
            return  "https://api.tvmaze.com/seasons/\(id)/episodes"
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var task: BaseCodable? {
        return nil
    }
    
    var header: BaseCodable? {
        return nil
    }
    
    
}
