//
//  ActivityForecastViewModel.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class ActivityForecastViewModel {

    private(set) var state: ForecastViewState = .idle

    let city: City

    private let forecastService: any ForecastProviding
    private let scoringService: any ActivityScoring

    init(
        city: City,
        forecastService: any ForecastProviding,
        scoringService: any ActivityScoring = WeatherSuitabilityScorer()
    ) {
        self.city = city
        self.forecastService = forecastService
        self.scoringService = scoringService
    }

    func loadForecast() async {

        guard case .idle = state else {
            return
        }

        state = .loading

        do {
            let forecasts = try await forecastService.fetchForecast(for: city)

            guard !Task.isCancelled else {
                state = .idle
                return
            }

            guard !forecasts.isEmpty else {
                state = .empty
                return
            }

            let scores = forecasts.flatMap {
                scoringService.score($0)
            }

            state = .loaded(
                forecasts: forecasts,
                scores: scores
            )

        } catch {

            guard !Task.isCancelled else {
                state = .idle
                return
            }

            state = .failed(error.localizedDescription)
        }
    }

    func retry() async {
        state = .idle
        await loadForecast()
    }
}

enum ForecastViewState {
    case idle
    case loading
    case loaded(
        forecasts: [DailyForecast],
        scores: [ActivityScore]
    )
    case empty
    case failed(String)
}
