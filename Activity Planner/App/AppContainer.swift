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
    let recentSearchStore: any RecentSearchStoring

    init(apiClient: APIClient = APIClient(),
         recentSearchStore: any RecentSearchStoring = UserDefaultsRecentSearchStore()) {
        
        self.citySearchService = OpenMeteoLocationRepository(apiClient: apiClient)
        self.forecastService = OpenMeteoWeatherRepository(apiClient: apiClient)
        self.recentSearchStore = recentSearchStore
    }

    init(
        citySearchService: any CitySearching,
        forecastService: any ForecastProviding,
        recentSearchStore: any RecentSearchStoring =
        UserDefaultsRecentSearchStore()
    ) {
        self.citySearchService = citySearchService
        self.forecastService = forecastService
        self.recentSearchStore = recentSearchStore
    }
}
