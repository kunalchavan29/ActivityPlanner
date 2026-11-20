//
//  ContentView.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import SwiftUI

struct ContentView: View {
    let container: AppContainer

    var body: some View {
        HomeView(
            citySearchService: container.citySearchService,
            forecastService: container.forecastService,
            recentSearchStore: container.recentSearchStore
        )
    }
}

#Preview {
    ContentView(container: AppContainer())
}
