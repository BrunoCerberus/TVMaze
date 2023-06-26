//
//  HomeAPI.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

enum HomeAPI {
    case fetchSeries
    case fetchSearch(String)
}

extension HomeAPI: Fetcher {
    var path: String {
        switch self {
        case .fetchSeries:
            return "https://api.tvmaze.com/shows"
        case let .fetchSearch(query):
            return "https://api.tvmaze.com/search/shows?q=\(query)"
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
