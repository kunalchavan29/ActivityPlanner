//
//  WeatherSuitabilityScorer.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation

struct WeatherSuitabilityScorer: ActivityScoring {

    func score(_ forecast: DailyForecast) -> [ActivityScore] {
        Activity.allCases.map { activity in
            score(forecast, for: activity)
        }
    }

    private func score(_ forecast: DailyForecast, for activity: Activity) -> ActivityScore {
        let components: [(Double?, Double)]
        let explanation: [String]

        switch activity {

        case .skiing:
            components = [
                (forecast.snowfallAmount.map { snowScore($0) }, 0.50),
                (forecast.temperatureMax.map { skiingTemperatureScore($0) }, 0.25),
                (forecast.windSpeedMax.map { windScore($0, idealMaximum: 25) }, 0.25)
            ]

            explanation = [
                "Based on forecast snowfall, temperature and wind.",
                "Actual snow depth and resort conditions are not included."
            ]

        case .surfing:
            components = [
                (forecast.windSpeedMax.map { surfingWindScore($0) }, 0.45),
                (forecast.temperatureMax.map { warmTemperatureScore($0) }, 0.25),
                (forecast.precipitationProbability.map { 100 - $0 }, 0.15),
                (forecast.sunshineDuration.map { sunshineScore($0) }, 0.15)
            ]

            explanation = [
                "Based on wind, temperature and general weather.",
                "Wave height, swell period and tide are not included."
            ]

        case .outdoorSightseeing:
            components = [
                (forecast.temperatureMax.map { comfortableTemperatureScore($0) }, 0.35),
                (forecast.precipitationProbability.map { 100 - $0 }, 0.30),
                (forecast.windSpeedMax.map { windScore($0, idealMaximum: 20) }, 0.20),
                (forecast.sunshineDuration.map { sunshineScore($0) }, 0.15)
            ]

            explanation = [
                "Based on comfortable temperatures, low rain probability and wind."
            ]

        case .indoorSightseeing:
            components = [
                (forecast.precipitationProbability, 0.40),
                (forecast.temperatureMax.map { uncomfortableTemperatureScore($0) }, 0.30),
                (forecast.windSpeedMax.map { windScore($0, idealMaximum: 45) }.map { 100 - $0 }, 0.20),
                (forecast.sunshineDuration.map { 100 - sunshineScore($0) }, 0.10)
            ]

            explanation = [
                "Higher scores favour rainy, uncomfortable or windy weather."
            ]
        }

        let finalScore = weightedAverage(components)

        return ActivityScore(
            activity: activity,
            date: forecast.date,
            score: Int(finalScore.rounded()),
            explanation: explanation
        )
    }

    // MARK: - Weighted Average

    private func weightedAverage(
        _ components: [(Double?, Double)]
    ) -> Double {

        let available = components.compactMap { value, weight -> (Double, Double)? in
            guard let value else { return nil }
            return (min(max(value, 0), 100), weight)
        }

        let totalWeight = available.reduce(0) { $0 + $1.1 }

        guard totalWeight > 0 else {
            return 0
        }

        let weightedTotal = available.reduce(0) {
            $0 + ($1.0 * $1.1)
        }

        return weightedTotal / totalWeight
    }

    // MARK: - Individual Scoring Rules

    private func snowScore(_ snowfall: Double) -> Double {
        switch snowfall {
        case 5...: return 100
        case 2..<5: return 80
        case 0.5..<2: return 55
        case 0..<0.5: return 20
        default: return 0
        }
    }

    private func skiingTemperatureScore(_ temperature: Double) -> Double {
        switch temperature {
        case -8...0: return 100
        case -12 ..< -8, 0..<5: return 75
        case -18 ..< -12, 5..<10: return 40
        default: return 15
        }
    }

    private func surfingWindScore(_ wind: Double) -> Double {
        switch wind {
        case 10...25: return 85
        case 5..<10, 25..<35: return 65
        case 0..<5, 35..<45: return 35
        default: return 15
        }
    }

    private func warmTemperatureScore(_ temperature: Double) -> Double {
        switch temperature {
        case 22...30: return 100
        case 18..<22, 30..<35: return 75
        case 12..<18, 35..<40: return 45
        default: return 20
        }
    }

    private func comfortableTemperatureScore(_ temperature: Double) -> Double {
        switch temperature {
        case 18...26: return 100
        case 14..<18, 26..<30: return 75
        case 8..<14, 30..<35: return 45
        default: return 20
        }
    }

    private func uncomfortableTemperatureScore(_ temperature: Double) -> Double {
        100 - comfortableTemperatureScore(temperature)
    }

    private func windScore(
        _ wind: Double,
        idealMaximum: Double
    ) -> Double {
        guard wind >= 0 else { return 0 }

        if wind <= idealMaximum {
            return 100
        }

        return max(
            0,
            100 - ((wind - idealMaximum) * 4)
        )
    }

    private func sunshineScore(_ seconds: Double) -> Double {
        // Open-Meteo provides sunshine duration in seconds.
        let hours = seconds / 3600
        return min(100, max(0, hours / 10 * 100))
    }
}
