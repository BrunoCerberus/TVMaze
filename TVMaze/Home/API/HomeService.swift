//
//  HomeService.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

protocol HomeServiceProtocol {
    func fetchSeries() async throws -> SeriesResponse
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
}
