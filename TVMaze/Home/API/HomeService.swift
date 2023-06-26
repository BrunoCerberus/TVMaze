//
//  HomeService.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

protocol HomeServiceProtocol {
    func fetchSeries() async throws -> SeriesResponse
    func fetchSearch(_ query: String) async throws -> SearchSeriesResponse
}

final class HomeService: APIDataFetcher<HomeAPI>, HomeServiceProtocol {
    func fetchSeries() async throws -> SeriesResponse {
        try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: .fetchSeries, dataType: SeriesResponse.self) { result in
                switch result {
                case let .success(response):
                    return continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchSearch(_ query: String) async throws -> SearchSeriesResponse {
        try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: .fetchSearch(query), dataType: SearchSeriesResponse.self) { result in
                switch result {
                case let .success(response):
                    return continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
