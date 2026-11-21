//
//  RouteDestinationView.swift
//  Activity Planner
//
//  Created by Kunal on 21/11/26.
//

import SwiftUI

struct RouteDestinationView: View {
    let route: AppRoute
    @Environment(AppContainer.self) private var container

    var body: some View {
        switch route {
        case .city(let city):
            ActivityForecastView(city: city, forecastService: container.forecastService)
            
        case .activityDetails(let activity, let forecasts, let scores):
            ActivityDetailsView(activity: activity, forecasts: forecasts, scores: scores)
        }
    }
}

private struct RouteDestinationsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.navigationDestination(for: AppRoute.self) { route in
            RouteDestinationView(route: route)
        }
    }
}

extension View {
    /// Registers all app route destinations on the enclosing navigation stack.
    func withRouteDestinations() -> some View {
        modifier(RouteDestinationsModifier())
    }
}
