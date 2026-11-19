//
//  AppContainer.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

struct AppContainer {

    let citySearchService: any CitySearching
    let forecastService: any ForecastProviding

    init(apiClient: APIClient = APIClient()) {
        self.citySearchService = OpenMeteoLocationRepository(apiClient: apiClient)
        self.forecastService = OpenMeteoWeatherRepository(apiClient: apiClient)
    }

    init(citySearchService: any CitySearching, forecastService: any ForecastProviding) {
        self.citySearchService = citySearchService
        self.forecastService = forecastService
    }
}
