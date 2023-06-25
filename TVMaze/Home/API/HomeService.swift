//
//  HomeService.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

protocol HomeServiceProtocol {
    func fetchSeries(_ completion: @escaping (Result<SeriesResponse, Error>) -> Void)
}

final class HomeService: APIDataFetcher<HomeAPI>, HomeServiceProtocol {
    func fetchSeries(_ completion: @escaping (Result<SeriesResponse, Error>) -> Void) {
        super.fetch(target: .fetchSeries, dataType: SeriesResponse.self, completion: completion)
    }
}
