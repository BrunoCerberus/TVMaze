//
//  HomeClient.swift
//  TVMaze
//
//  Created by bruno on 25/06/23.
//

import ComposableArchitecture

struct NFTCollectionClient {
    var fetchSeries: () -> EffectPublisher<SeriesResponse, Failure>
    
    enum Failure: Error, Equatable {
        case fetchSeriesError(String)
    }
}

extension NFTCollectionClient {
    static let live: NFTCollectionClient = NFTCollectionClient(
        fetchSeries: {
            EffectPublisher.future { callback in
                let service: HomeServiceProtocol = HomeService()
                service.fetchSeries { result in
                    switch result {
                    case let .success(response):
                        callback(.success(response))
                    case let .failure(error):
                        callback(.failure(Failure.fetchSeriesError(error.localizedDescription)))
                    }
                }
            }
        }
    )
    
    static let dev: NFTCollectionClient = NFTCollectionClient(
        fetchSeries: {
            EffectPublisher(value: [])
        }
    )
}
