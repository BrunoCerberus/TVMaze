//
//  Home.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        @PresentationState var serieDetail: SerieDetails.State?
        @BindingState var searchText: String = ""
        var series: IdentifiedArrayOf<Series> = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case seriesDetail
        case search
        case fetchSeries
        case fetchSeriesResponse(TaskResult<SeriesResponse>)
        case serieDetailsDispatch(PresentationAction<SerieDetails.Action>)
        case openSerie(Int, String)
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce(self.core)
            .ifLet(\.$serieDetail, action: /Action.serieDetailsDispatch) {
                SerieDetails()
            }
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.homeClient) var homeClient
    private enum CancelID { case searchInput }
    
    func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding(\.$searchText):
            return .run { send in
                try await self.clock.sleep(for: .seconds(1))
                await send(.search, animation: .default)
            }
            .cancellable(id: CancelID.searchInput, cancelInFlight: true)
        case .seriesDetail:
            return .none
        case .search:
            print(state.searchText)
            return .none
        case .fetchSeries:
            return .run { send in
                await send(.fetchSeriesResponse(TaskResult { try await self.homeClient.fetchSeries() }))
            }
        case let .fetchSeriesResponse(.success(response)):
            state.series = IdentifiedArrayOf(uniqueElements: response)
            return .none
        case let .fetchSeriesResponse(.failure(error)):
            return .none
        case .serieDetailsDispatch:
            return .none
        case let .openSerie(serieID, cover):
            state.serieDetail = SerieDetails.State(
                posterImageURL: cover,
                serieID: serieID
            )
            return .none
        case .binding:
            return .none
        }
    }
}
