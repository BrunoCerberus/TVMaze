//
//  SerieDetailsService.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

protocol SerieDetailsServiceProtocol {
    func fetchSeasons(_ id: Int) async throws -> SeasonsDetailsResponse
    func fetchEpisodes(_ id: Int) async throws -> EpisodesDetailsResponse
}

final class SerieDetailsService: APIDataFetcher<SeasonsDetailsAPI>, SerieDetailsServiceProtocol {
    func fetchSeasons(_ id: Int) async throws -> SeasonsDetailsResponse {
        try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: .fetchSeasons(id), dataType: SeasonsDetailsResponse.self) { result in
                switch result {
                case let .success(response):
                    return continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchEpisodes(_ id: Int) async throws -> EpisodesDetailsResponse {
        try await withCheckedThrowingContinuation { continuation in
            super.fetch(target: .fetchEpisodes(id), dataType: EpisodesDetailsResponse.self) { result in
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
