//
//  ContentView.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import SwiftUI

struct ContentView: View {
    let container: AppContainer
    
    @Environment(AppCoordinator.self) private var coordinator

    var body: some View {
        @Bindable var coordinator = coordinator
        
        NavigationStack(path: $coordinator.path) {
            HomeView(
                citySearchService: container.citySearchService,
                forecastService: container.forecastService,
                recentSearchStore: container.recentSearchStore
            )
            .withRouteDestinations()
        }
    }
}

#Preview {
    ContentView(container: AppContainer())
}
