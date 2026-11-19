//
//  WeatherResponse.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

nonisolated struct WeatherResponse: Decodable, Sendable {
    let timezone: String
    let daily: DailyWeatherResponse
}

struct DailyWeatherResponse: Decodable, Sendable {

    let time: [String]
    let temperatureMax: [Double?]?
    let temperatureMin: [Double?]?
    let precipitationProbability: [Double?]?
    let precipitationAmount: [Double?]?
    let snowfallAmount: [Double?]?
    let windSpeedMax: [Double?]?
    let sunshineDuration: [Double?]?
    let weatherCode: [Int?]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitationProbability = "precipitation_probability_max"
        case precipitationAmount = "precipitation_sum"
        case snowfallAmount = "snowfall_sum"
        case windSpeedMax = "wind_speed_10m_max"
        case sunshineDuration = "sunshine_duration"
        case weatherCode = "weather_code"
    }

    func toDomain(
        timeZoneIdentifier: String
    ) -> [DailyForecast] {

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier)
            ?? TimeZone(secondsFromGMT: 0)!
        formatter.dateFormat = "yyyy-MM-dd"

        return time.enumerated().compactMap { index, dateString -> DailyForecast? in

            guard let date = formatter.date(from: dateString) else {
                return nil
            }

            return DailyForecast(
                date: date,
                temperatureMax: temperatureMax?.value(at: index).flattened(),
                temperatureMin: temperatureMin?.value(at: index).flattened(),
                precipitationProbability: precipitationProbability?.value(at: index).flattened(),
                precipitationAmount: precipitationAmount?.value(at: index).flattened(),
                snowfallAmount: snowfallAmount?.value(at: index).flattened(),
                windSpeedMax: windSpeedMax?.value(at: index).flattened(),
                sunshineDuration: sunshineDuration?.value(at: index).flattened(),
                weatherCode: weatherCode?.value(at: index).flattened()
            )
        }
    }
}


private extension Array {
    func value(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}

private extension Optional {
    func flattened<T>() -> T? where Wrapped == T? {
        self ?? nil
    }
}
