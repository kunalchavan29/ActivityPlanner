//
//  WeatherSuitabilityScorerTests.swift
//  AppCast
//
//  Created by Kunal on 19/11/26.
//
import XCTest
@testable import Activity_Planner

@MainActor
final class WeatherSuitabilityScorerTests: XCTestCase {

    private let sut = WeatherSuitabilityScorer()

    func testReturnsOneScoreForEachActivity() {

        let scores = sut.score(makeForecast())

        XCTAssertEqual(scores.count, Activity.allCases.count)
        XCTAssertEqual(
            Set(scores.map(\.activity)),
            Set(Activity.allCases)
        )
    }

    func testScoresAreWithinZeroAndOneHundred() {

        let scores = sut.score(makeForecast())

        for score in scores {
            XCTAssertGreaterThanOrEqual(score.score, 0)
            XCTAssertLessThanOrEqual(score.score, 100)
        }
    }

    func testMissingWeatherValuesReturnZeroScores() {

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

    func testIdealOutdoorWeatherProducesHighScore() {

        let forecast = DailyForecast(
            date: Date(),
            temperatureMax: 22,
            temperatureMin: 15,
            precipitationProbability: 0,
            precipitationAmount: 0,
            snowfallAmount: 0,
            windSpeedMax: 5,
            sunshineDuration: 36000,
            weatherCode: 1
        )

        let outdoorScore = sut.score(forecast).first {
            $0.activity == .outdoorSightseeing
        }

        XCTAssertNotNil(outdoorScore)
        XCTAssertGreaterThanOrEqual(outdoorScore?.score ?? 0, 80)
    }

    private func makeForecast() -> DailyForecast {
        DailyForecast(
            date: Date(),
            temperatureMax: 24,
            temperatureMin: 15,
            precipitationProbability: 10,
            precipitationAmount: 0,
            snowfallAmount: 0,
            windSpeedMax: 10,
            sunshineDuration: 36000,
            weatherCode: 1
        )
    }
}
