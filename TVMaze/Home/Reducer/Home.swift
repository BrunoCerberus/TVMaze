//
//  Home.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        var viewState: ViewState = .idle
        @PresentationState var serieDetail: SerieDetails.State?
        @BindingState var searchText: String = ""
        var series: IdentifiedArrayOf<Series> = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case seriesDetail
        case fetchSeries
        case fetchSeriesResponse(TaskResult<SeriesResponse>)
        case fetchSearchSeries
        case fetchSearchSeriesResponse(TaskResult<SearchSeriesResponse>)
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
            return .run { [searchText = state.searchText] send in
                try await self.clock.sleep(for: .seconds(1))
                if searchText.isEmpty {
                    await send(.fetchSeries, animation: .default)
                } else {
                    await send(.fetchSearchSeries, animation: .default)
                }
            }
            .cancellable(id: CancelID.searchInput, cancelInFlight: true)
        case .seriesDetail:
            return .none
        case .fetchSearchSeries:
            state.viewState = .loading
            return .run { [searchText = state.searchText] send in
                await send(.fetchSearchSeriesResponse(TaskResult { try await self.homeClient.fetchSearch(searchText) }))
            }
        case let .fetchSearchSeriesResponse(.success(response)):
            state.viewState = .loaded
            state.series = IdentifiedArrayOf(uniqueElements: response.map { $0.show })
            return .none
        case .fetchSearchSeriesResponse(.failure):
            state.viewState = .loaded
            return .none
        case .fetchSeries:
            state.viewState = .loading
            return .run { send in
                await send(.fetchSeriesResponse(TaskResult { try await self.homeClient.fetchSeries() }))
            }
        case let .fetchSeriesResponse(.success(response)):
            state.viewState = .loaded
            state.series = IdentifiedArrayOf(uniqueElements: response)
            return .none
        case .fetchSeriesResponse(.failure):
            state.viewState = .loaded
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
