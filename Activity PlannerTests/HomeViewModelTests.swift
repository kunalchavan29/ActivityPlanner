//
//  HomeViewModelTests.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import XCTest
@testable import Activity_Planner

@MainActor
final class HomeViewModelTests: XCTestCase {

    // MARK: - Initial State

    func testInitialStateHasNoRecentSearches() {
        let viewModel = makeViewModel()

        XCTAssertTrue(viewModel.recentSearches.isEmpty)
    }

    // MARK: - Load Recent Searches

    func testLoadRecentSearchesUpdatesViewModel() async {
        // Arrange
        let pune = makeCity(
            id: 1,
            name: "Pune"
        )

        let mumbai = makeCity(
            id: 2,
            name: "Mumbai"
        )

        let store = MockRecentSearchStore(
            cities: [pune, mumbai]
        )

        let viewModel = makeViewModel(
            recentSearchStore: store
        )

        // Act
        await viewModel.loadRecentSearches()

        // Assert
        XCTAssertEqual(
            viewModel.recentSearches,
            [pune, mumbai]
        )

        let counts = await store.callCounts()
        XCTAssertEqual(counts.load, 1)
    }

    func testLoadRecentSearchesWhenStoreIsEmpty() async {
        // Arrange
        let store = MockRecentSearchStore()
        let viewModel = makeViewModel(
            recentSearchStore: store
        )

        // Act
        await viewModel.loadRecentSearches()

        // Assert
        XCTAssertTrue(viewModel.recentSearches.isEmpty)
    }

    // MARK: - Select City

    func testSelectCityAddsCityToRecentSearches() async {
        // Arrange
        let pune = makeCity(
            id: 1,
            name: "Pune"
        )

        let store = MockRecentSearchStore()
        let viewModel = makeViewModel(
            recentSearchStore: store
        )

        // Act
        await viewModel.selectCity(pune)

        // Assert
        XCTAssertEqual(
            viewModel.recentSearches,
            [pune]
        )

        let persistedCities = await store.storedCities()

        XCTAssertEqual(persistedCities, [pune])

        let counts = await store.callCounts()
        XCTAssertEqual(counts.save, 1)
    }

    func testSelectCityAddsLatestCityAtBeginning() async {
        // Arrange
        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")

        let store = MockRecentSearchStore(
            cities: [pune]
        )

        let viewModel = makeViewModel(
            recentSearchStore: store
        )

        // Act
        await viewModel.loadRecentSearches()
        await viewModel.selectCity(mumbai)

        // Assert
        XCTAssertEqual(
            viewModel.recentSearches,
            [mumbai, pune]
        )
    }

    // MARK: - Clear Recent Searches

    func testClearRecentSearchesRemovesAllCities() async {
        // Arrange
        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")

        let store = MockRecentSearchStore(
            cities: [pune, mumbai]
        )

        let viewModel = makeViewModel(
            recentSearchStore: store
        )

        await viewModel.loadRecentSearches()

        // Act
        await viewModel.clearRecentSearches()

        // Assert
        XCTAssertTrue(viewModel.recentSearches.isEmpty)

        let persistedCities = await store.storedCities()
        XCTAssertTrue(persistedCities.isEmpty)

        let counts = await store.callCounts()
        XCTAssertEqual(counts.clear, 1)
    }

    // MARK: - Helpers

    private func makeViewModel(
        recentSearchStore: any RecentSearchStoring =
            MockRecentSearchStore()
    ) -> HomeViewModel {

        HomeViewModel(
            citySearchService: MockCitySearchService(),
            recentSearchStore: recentSearchStore
        )
    }

    private func makeCity(
        id: Int,
        name: String
    ) -> City {

        City(
            id: id,
            name: name,
            country: "India",
            region: "Maharashtra",
            latitude: 18.5204,
            longitude: 73.8567,
            timezone: "Asia/Kolkata"
        )
    }
}
