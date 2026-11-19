//
//  ActivityScoringTests.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import XCTest
@testable import Activity_Planner

@MainActor
final class ActivityScoringTests: XCTestCase {

    private let sut = WeatherSuitabilityScorer()

    func testScoreReturnsAllFourActivities() {

        let forecast = makeForecast(
            temperature: 24,
            precipitation: 10,
            snowfall: 0,
            wind: 10,
            sunshine: 36000
        )

        let scores = sut.score(forecast)

        XCTAssertEqual(scores.count, 4)
        XCTAssertEqual(
            Set(scores.map(\.activity)),
            Set(Activity.allCases)
        )
    }

    func testAllScoresAreWithinValidRange() {

        let forecast = makeForecast(
            temperature: 24,
            precipitation: 10,
            snowfall: 0,
            wind: 10,
            sunshine: 36000
        )

        let scores = sut.score(forecast)

        for score in scores {
            XCTAssertTrue((0...100).contains(score.score))
        }
    }

    func testMissingWeatherValuesDoNotCrashScoring() {

        let forecast = DailyForecast(
            date: Date(),
            temperatureMax: nil,
            temperatureMin: nil,
            precipitationProbability: nil,
            precipitationAmount: nil,
            snowfallAmount: nil,
            windSpeedMax: nil,
            sunshineDuration: nil,
            weatherCode: nil
        )

        let scores = sut.score(forecast)

        XCTAssertEqual(scores.count, 4)
        XCTAssertTrue(scores.allSatisfy { $0.score == 0 })
    }

    private func makeForecast(
        temperature: Double,
        precipitation: Double,
        snowfall: Double,
        wind: Double,
        sunshine: Double
    ) -> DailyForecast {

        DailyForecast(
            date: Date(),
            temperatureMax: temperature,
            temperatureMin: 15,
            precipitationProbability: precipitation,
            precipitationAmount: 0,
            snowfallAmount: snowfall,
            windSpeedMax: wind,
            sunshineDuration: sunshine,
            weatherCode: 1
        )
    }
}
