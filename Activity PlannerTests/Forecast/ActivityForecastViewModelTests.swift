//
//  ActivityForecastViewModelTests.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import XCTest
@testable import Activity_Planner

@MainActor
final class ActivityForecastViewModelTests: XCTestCase {

    private let pune = City(
        id: 1,
        name: "Pune",
        country: "India",
        region: "Maharashtra",
        latitude: 18.5204,
        longitude: 73.8567,
        timezone: "Asia/Kolkata"
    )

    func testInitialStateIsIdle() {

        let viewModel = ActivityForecastViewModel(
            city: pune,
            forecastService: MockForecastService()
        )

        XCTAssertTrue(isIdle(viewModel.state))
    }

    func testSuccessfulForecastLoading() async {

        let forecast = makeForecast()

        let service = MockForecastService(
            forecasts: [forecast]
        )

        let viewModel = ActivityForecastViewModel(
            city: pune,
            forecastService: service
        )

        await viewModel.loadForecast()

        guard case .loaded(let forecasts, let scores) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }

        XCTAssertEqual(forecasts.count, 1)
        XCTAssertEqual(scores.count, 4)
    }

    func testEmptyForecastResponse() async {

        let viewModel = ActivityForecastViewModel(
            city: pune,
            forecastService: MockForecastService()
        )

        await viewModel.loadForecast()

        XCTAssertTrue(isEmpty(viewModel.state))
    }

    func testForecastError() async {

        let service = MockForecastService(
            shouldThrowError: true
        )

        let viewModel = ActivityForecastViewModel(
            city: pune,
            forecastService: service
        )

        await viewModel.loadForecast()

        guard case .failed(let message) = viewModel.state else {
            return XCTFail("Expected failed state")
        }

        XCTAssertEqual(message, "Mock forecast failed")
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

    private func isIdle(_ state: ForecastViewState) -> Bool {
        if case .idle = state { return true }
        return false
    }

    private func isEmpty(_ state: ForecastViewState) -> Bool {
        if case .empty = state { return true }
        return false
    }
}
