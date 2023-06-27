//
//  SerieDetailsClient.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

extension DependencyValues {
  var serieDetailsClient: SerieDetailsClient {
    get { self[SerieDetailsClient.self] }
    set { self[SerieDetailsClient.self] = newValue }
  }
}

struct SerieDetailsClient {
    var fetchSeasons: @Sendable (Int) async throws -> SeasonsDetailsResponse
    var fetchEpisodes: @Sendable (Int) async throws -> EpisodesDetailsResponse
    
    enum Failure: Error, Equatable {
        case fetchSeriesError(String)
    }
}

extension SerieDetailsClient: DependencyKey {
    /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
    /// Typically this live implementation of the dependency would live in its own module so that the
    /// main feature doesn't need to compile it.
    static let liveValue = Self(
        fetchSeasons: { serie in
            let service: SerieDetailsServiceProtocol = SerieDetailsService()
            return try await service.fetchSeasons(serie)
        },
        fetchEpisodes: { season in
            let service: SerieDetailsServiceProtocol = SerieDetailsService()
            return try await service.fetchEpisodes(season)
        }
    )
}

extension SerieDetailsClient: TestDependencyKey {
    static let testValue = Self(
        fetchSeasons: { _ in [] },
        fetchEpisodes: { _ in [] }
    )
}
