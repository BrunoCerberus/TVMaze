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
    init() {
        let coloredNavAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
        
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = UIColor(Color.black)
        coloredNavAppearance.shadowColor = UIColor(Color.black)
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.white20)
        UITabBar.appearance().barTintColor = UIColor(Color.black)
        UITabBar.appearance().isTranslucent = false
        
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITextView.appearance().backgroundColor = .clear
    }

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
