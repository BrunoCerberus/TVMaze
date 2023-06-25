//
//  HomeAPI.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

enum HomeAPI {
    case fetchSeries
}

extension HomeAPI: Fetcher {
    var path: String {
        return "https://api.tvmaze.com/shows"
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
