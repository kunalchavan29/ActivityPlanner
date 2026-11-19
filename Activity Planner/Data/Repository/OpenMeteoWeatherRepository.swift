//
//  OpenMeteoWeatherRepository.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

struct OpenMeteoWeatherRepository: ForecastProviding {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchForecast(
        for city: City
    ) async throws -> [DailyForecast] {

        let response: WeatherResponse = try await apiClient.request(
            .forecast(
                latitude: city.latitude,
                longitude: city.longitude
            )
        )

        return response.daily.toDomain(timeZoneIdentifier: response.timezone)
    }
}
