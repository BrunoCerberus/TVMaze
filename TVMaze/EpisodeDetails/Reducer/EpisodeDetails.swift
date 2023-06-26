//
//  EpisodeDetails.swift
//  TVMaze
//
//  Created by bruno on 26/06/23.
//

import ComposableArchitecture

struct EpisodeDetails: ReducerProtocol {
    struct State: Equatable {
        var episode: EpisodesDetails
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocolOf<Self> {
        BindingReducer()
        Reduce(self.core)
    }
    
    func core(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            return .none
        }
    }
}

