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
        CitySearchView(
            citySearchService: container.citySearchService,
            forecastService: container.forecastService
        )
    }
}

#Preview {
    ContentView(
        container: AppContainer()
    )
}
