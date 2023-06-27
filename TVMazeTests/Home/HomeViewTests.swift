//
//  HomeViewTests.swift
//  TVMazeTests
//
//  Created by bruno on 26/06/23.
//

@testable import TVMaze
import ComposableArchitecture
import SwiftUI

final class HomeViewTests: BaseXCTestCase {
    
    private let record: Bool = false
    
    func test_Home_With_Skeleton() {
        withDependencies({ $0.homeClient = .testValue }) {
            let view: some View = HomeView(store: Store(initialState: Home.State(viewState: .loading), reducer: EmptyReducer())).padding(.vertical)
            ciAssertSnapshot(matching: view.wrappedInViewController, as: .image(precision: snapshotPrecision), record: record)
        }
    }
    
    func test_Home_With_Mock() {
        let series: IdentifiedArrayOf<Series> = [.mock]
        withDependencies({ $0.homeClient = .testValue }) {
            let view: some View = HomeView(store: Store(initialState: Home.State(viewState: .loaded, series: series), reducer: EmptyReducer())).padding(.vertical)
            ciAssertSnapshot(matching: view.wrappedInViewController, as: .image(precision: snapshotPrecision), record: record)
        }
    }
}
