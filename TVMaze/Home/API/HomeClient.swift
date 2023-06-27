//
//  HomeClient.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

extension DependencyValues {
  var homeClient: HomeClient {
    get { self[HomeClient.self] }
    set { self[HomeClient.self] = newValue }
  }
}

struct HomeClient {
    var fetchSeries: @Sendable () async throws -> SeriesResponse
    var fetchSearch: @Sendable (String) async throws -> SearchSeriesResponse
    
    enum Failure: Error, Equatable {
        case fetchSeriesError(String)
    }
}

extension HomeClient: DependencyKey {
    /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
    /// Typically this live implementation of the dependency would live in its own module so that the
    /// main feature doesn't need to compile it.
    static let liveValue = Self(
        fetchSeries: {
            let service: HomeServiceProtocol = HomeService()
            return try await service.fetchSeries()
        },
        fetchSearch: { query in
            let service: HomeServiceProtocol = HomeService()
            return try await service.fetchSearch(query)
        }
    )
}

extension HomeClient: TestDependencyKey {
    static let testValue = Self(
        fetchSeries: { [] },
        fetchSearch: { _ in [] }
    )
}
