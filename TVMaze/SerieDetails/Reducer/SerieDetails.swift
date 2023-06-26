//
//  SerieDetails.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

struct SerieDetails: ReducerProtocol {
    struct State: Equatable {
        @BindingState var currentPage: Int = 0
        var posterImageURL: String = ""
        var serieID: Int = 0
        var seasons: IdentifiedArrayOf<SeasonsDetails> = []
        var episodes: IdentifiedArrayOf<EpisodesDetails> = []
        
        var seasonID: Int {
            seasons[currentPage].id
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case fetchSeasons
        case fetchSeasonsResponse(TaskResult<SeasonsDetailsResponse>)
        case fetchEpisodes
        case fetchEpisodesResponse(TaskResult<EpisodesDetailsResponse>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce(self.core)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.serieDetailsClient) var serieDetailsClient
    private enum CancelID {
        case seasonRequest
        case episodesRequest
    }
    
    func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding(\.$currentPage):
            return .task { .fetchSeasons }
        case .fetchSeasons:
            return .run { [serieID = state.serieID] send in
                await send(.fetchSeasonsResponse(TaskResult { try await self.serieDetailsClient.fetchSeasons(serieID) }))
            }
            .cancellable(id: CancelID.seasonRequest, cancelInFlight: true)
        case let .fetchSeasonsResponse(.success(response)):
            state.seasons = IdentifiedArrayOf(uniqueElements: response)
            return .task { .fetchEpisodes }
        case let .fetchSeasonsResponse(.failure(error)):
            return .none
        case .fetchEpisodes:
            return .run { [seasonID = state.seasonID] send in
                await send(.fetchEpisodesResponse(TaskResult { try await self.serieDetailsClient.fetchEpisodes(seasonID) }))
            }
            .cancellable(id: CancelID.episodesRequest, cancelInFlight: true)
        case let .fetchEpisodesResponse(.success(response)):
            state.episodes = IdentifiedArrayOf(uniqueElements: response)
            return .none
        case let .fetchEpisodesResponse(.failure(error)):
            return .none
        case .binding:
            return .none
        }
    }
}

