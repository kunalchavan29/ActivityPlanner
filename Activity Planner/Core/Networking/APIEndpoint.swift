//
//  APIEndpoint.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

enum APIEndpoint {

    case geocoding(query: String)
    case forecast(latitude: Double, longitude: Double)

    var url: URL? {

        var components: URLComponents

        switch self {

        case .geocoding(let query):

            components = URLComponents(
                string: "https://geocoding-api.open-meteo.com/v1/search"
            )!

            components.queryItems = [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]

        case .forecast(let latitude, let longitude):

            components = URLComponents(
                string: "https://api.open-meteo.com/v1/forecast"
            )!

            let dailyVariables = [
                "temperature_2m_max",
                "temperature_2m_min",
                "precipitation_probability_max",
                "precipitation_sum",
                "snowfall_sum",
                "wind_speed_10m_max",
                "sunshine_duration",
                "weather_code"
            ]

            components.queryItems = [
                URLQueryItem(
                    name: "latitude",
                    value: String(latitude)
                ),
                URLQueryItem(
                    name: "longitude",
                    value: String(longitude)
                ),
                URLQueryItem(
                    name: "daily",
                    value: dailyVariables.joined(separator: ",")
                ),
                URLQueryItem(name: "timezone", value: "auto"),
                URLQueryItem(name: "forecast_days", value: "7"),
                URLQueryItem(name: "wind_speed_unit", value: "kmh")
            ]
        }

        return components.url
    }
}
