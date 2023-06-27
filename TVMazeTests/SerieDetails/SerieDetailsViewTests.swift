//
//  SerieDetailsViewTests.swift
//  TVMazeTests
//
//  Created by bruno on 26/06/23.
//

@testable import TVMaze
import ComposableArchitecture
import SwiftUI

final class SerieDetailsViewTests: BaseXCTestCase {
    
    private let record: Bool = false
    
    func test_SerieDetails_With_Skeleton() {
        let seasons: IdentifiedArrayOf<SeasonsDetails> = [.mock]
        let episodes: IdentifiedArrayOf<EpisodesDetails> = [.mock]
        let state: SerieDetails.State = .init(viewState: .loading, posterImageURL: "", seasons: seasons, episodes: episodes)
        withDependencies({ $0.serieDetailsClient = .testValue }) {
            let view: some View = SerieDetailsView(store: Store(initialState: state, reducer: EmptyReducer()))
            ciAssertSnapshot(matching: view.wrappedInViewController, as: .image(precision: snapshotPrecision), record: record)
        }
    }
    
    func test_SerieDetails_With_Mock() {
        let seasons: IdentifiedArrayOf<SeasonsDetails> = [.mock]
        let episodes: IdentifiedArrayOf<EpisodesDetails> = [.mock]
        let state: SerieDetails.State = .init(viewState: .loading, posterImageURL: "", seasons: seasons, episodes: episodes)
        withDependencies({ $0.serieDetailsClient = .testValue }) {
            let view: some View = SerieDetailsView(store: Store(initialState: state, reducer: EmptyReducer()))
            ciAssertSnapshot(matching: view.wrappedInViewController, as: .image(precision: snapshotPrecision), record: record)
        }
    }
}
