//
//  AppCoordinator.swift
//  Activity Planner
//
//  Created by Kunal on 21/11/26.
//
import SwiftUI
import Observation

enum AppRoute: Hashable {
    case city(City)
    case activityDetails(Activity, [DailyForecast], [ActivityScore])
}

@MainActor
@Observable
final class AppCoordinator {
    var path: [AppRoute] = []

    func showCity(_ city: City) {
        path.append(.city(city))
    }

    func showActivityDetails(activity: Activity, dailyForecast: [DailyForecast], scores: [ActivityScore]) {
        path.append(.activityDetails(activity, dailyForecast, scores))
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
