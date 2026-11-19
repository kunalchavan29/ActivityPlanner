//
//  MockForecastService.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import Foundation
@testable import Activity_Planner

struct MockForecastService: ForecastProviding {

    var forecasts: [DailyForecast] = []
    var shouldThrowError = false

    func fetchForecast(for city: City) async throws -> [DailyForecast] {

        if shouldThrowError {
            throw MockError.forecastFailed
        }

        return forecasts
    }
}
