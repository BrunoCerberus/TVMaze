//
//  TVMazeApp.swift
//  TVMaze
//
//  Created by bruno on 24/06/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct TVMazeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(store: Store(
                    initialState: Home.State(),
                    reducer: Home()
                ))
            }
            .preferredColorScheme(.dark)
        }
    }
}
