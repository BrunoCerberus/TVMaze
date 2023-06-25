//
//  Home.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        @BindingState var searchText: String = ""
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case seriesDetail
        case search
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce(self.core)
    }
    
    @Dependency(\.continuousClock) var clock
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
        case .binding:
            return .none
        }
    }
}
