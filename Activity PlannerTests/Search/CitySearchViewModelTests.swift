//
//  CitySearchViewModelTests.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import XCTest
@testable import Activity_Planner

@MainActor
final class CitySearchViewModelTests: XCTestCase {

    // MARK: - Initial State

    func testInitialStateIsIdle() {
        let viewModel = CitySearchViewModel(
            citySearchService: MockCitySearchService(),
            debounceDuration: .milliseconds(0)
        )

        XCTAssertEqual(viewModel.query, "")
        XCTAssertTrue(isIdle(viewModel.state))
    }

    // MARK: - Empty Query

    func testEmptyQueryResetsStateToIdle() {
        let viewModel = CitySearchViewModel(
            citySearchService: MockCitySearchService(),
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("Pune")
        viewModel.updateQuery("")

        XCTAssertEqual(viewModel.query, "")
        XCTAssertTrue(isIdle(viewModel.state))
    }

    func testWhitespaceQueryResetsStateToIdle() {
        let viewModel = CitySearchViewModel(
            citySearchService: MockCitySearchService(),
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("   ")

        XCTAssertTrue(isIdle(viewModel.state))
    }

    // MARK: - Successful Search

    func testSearchReturnsMatchingCities() async {
        let pune = City(
            id: 1,
            name: "Pune",
            country: "India",
            region: "Maharashtra",
            latitude: 18.5204,
            longitude: 73.8567,
            timezone: "Asia/Kolkata"
        )

        let service = MockCitySearchService(
            cities: [pune]
        )

        let viewModel = CitySearchViewModel(
            citySearchService: service,
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("Pune")

        await waitForSearch(viewModel)

        guard case .results(let cities) = viewModel.state else {
            return XCTFail("Expected search results")
        }

        XCTAssertEqual(cities.count, 1)
        XCTAssertEqual(cities.first?.name, "Pune")
    }

    // MARK: - Empty Results

    func testSearchReturnsEmptyResults() async {
        let viewModel = CitySearchViewModel(
            citySearchService: MockCitySearchService(),
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("UnknownCity")

        await waitForSearch(viewModel)

        XCTAssertTrue(isEmpty(viewModel.state))
    }

    // MARK: - Error Handling

    func testSearchHandlesAPIError() async {
        let service = MockCitySearchService(
            shouldThrowError: true
        )

        let viewModel = CitySearchViewModel(
            citySearchService: service,
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("Pune")

        await waitForSearch(viewModel)

        guard case .failed(let message) = viewModel.state else {
            return XCTFail("Expected failed state")
        }

        XCTAssertFalse(message.isEmpty)
    }

    // MARK: - Query Updates

    func testUpdatingQueryUpdatesViewModelQuery() {
        let viewModel = CitySearchViewModel(
            citySearchService: MockCitySearchService(),
            debounceDuration: .milliseconds(0)
        )

        viewModel.updateQuery("Mumbai")

        XCTAssertEqual(viewModel.query, "Mumbai")
    }

    // MARK: - Helpers

    private func waitForSearch(
        _ viewModel: CitySearchViewModel
    ) async {
        for _ in 0..<100 {
            if !isLoading(viewModel.state) {
                return
            }

            try? await Task.sleep(for: .milliseconds(10))
        }

        XCTFail("Search did not complete within expected time")
    }

    private func isIdle(_ state: CitySearchState) -> Bool {
        if case .idle = state {
            return true
        }
        return false
    }

    private func isLoading(_ state: CitySearchState) -> Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    private func isEmpty(_ state: CitySearchState) -> Bool {
        if case .empty = state {
            return true
        }
        return false
    }
}
