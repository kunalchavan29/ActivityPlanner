//
//  UserDefaultsRecentSearchStoreTests.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import XCTest
@testable import Activity_Planner

@MainActor
final class UserDefaultsRecentSearchStoreTests: XCTestCase {

    // MARK: - Load

    func testLoadReturnsEmptyArrayWhenStorageIsEmpty() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let cities = await store.load()

        XCTAssertTrue(cities.isEmpty)
    }

    func testLoadReturnsPreviouslyStoredCities() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")

        _ = await store.save(pune)
        _ = await store.save(mumbai)

        let loadedCities = await store.load()

        XCTAssertEqual(loadedCities, [mumbai, pune])
    }

    // MARK: - Save

    func testSaveAddsCityToRecentSearches() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let pune = makeCity(id: 1, name: "Pune")

        let cities = await store.save(pune)

        XCTAssertEqual(cities, [pune])
    }

    func testSaveAddsLatestCityAtBeginning() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")
        let bangalore = makeCity(id: 3, name: "Bangalore")

        _ = await store.save(pune)
        _ = await store.save(mumbai)
        let cities = await store.save(bangalore)

        XCTAssertEqual(
            cities,
            [bangalore, mumbai, pune]
        )
    }

    func testSavingDuplicateCityMovesItToBeginning() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")
        let bangalore = makeCity(id: 3, name: "Bangalore")

        _ = await store.save(pune)
        _ = await store.save(mumbai)
        _ = await store.save(bangalore)

        let cities = await store.save(pune)

        XCTAssertEqual(
            cities,
            [pune, bangalore, mumbai]
        )

        XCTAssertEqual(
            cities.filter { $0.id == pune.id }.count,
            1
        )
    }

    func testSaveMaintainsMaximumOfTenCities() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        var savedCities: [City] = []

        for id in 1...12 {
            let city = makeCity(
                id: id,
                name: "City \(id)"
            )

            savedCities = await store.save(city)
        }

        XCTAssertEqual(savedCities.count, 10)

        XCTAssertEqual(savedCities.first?.id, 12)
        XCTAssertEqual(savedCities.last?.id, 3)
    }

    // MARK: - Persistence

    func testSavedCitiesPersistAcrossStoreInstances() async {
        let suiteName = UUID().uuidString

        let defaults = UserDefaults(suiteName: suiteName)!

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let firstStore = UserDefaultsRecentSearchStore(
            suiteName: suiteName
        )

        let pune = makeCity(id: 1, name: "Pune")
        let mumbai = makeCity(id: 2, name: "Mumbai")

        _ = await firstStore.save(pune)
        _ = await firstStore.save(mumbai)

        // Create a new store using the same UserDefaults suite.
        let secondStore = UserDefaultsRecentSearchStore(
            suiteName: suiteName
        )

        let loadedCities = await secondStore.load()

        XCTAssertEqual(loadedCities, [mumbai, pune])
    }

    // MARK: - Clear

    func testClearRemovesAllRecentSearches() async {
        let (store, defaults, suiteName) = makeStore()

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        _ = await store.save(makeCity(id: 1, name: "Pune"))
        _ = await store.save(makeCity(id: 2, name: "Mumbai"))

        await store.clear()

        let cities = await store.load()

        XCTAssertTrue(cities.isEmpty)
    }

    func testClearRemovesPersistedData() async {
        let suiteName = UUID().uuidString
        let defaults = UserDefaults(suiteName: suiteName)!

        defer {
            defaults.removePersistentDomain(forName: suiteName)
        }

        let store = UserDefaultsRecentSearchStore(
            suiteName: suiteName
        )

        _ = await store.save(makeCity(id: 1, name: "Pune"))

        await store.clear()

        // Create another instance to verify persistent storage.
        let newStore = UserDefaultsRecentSearchStore(
            suiteName: suiteName
        )

        let cities = await newStore.load()

        XCTAssertTrue(cities.isEmpty)
    }

    // MARK: - Helpers

    private func makeStore() -> (
        UserDefaultsRecentSearchStore,
        UserDefaults,
        String
    ) {
        let suiteName = UUID().uuidString
        let defaults = UserDefaults(suiteName: suiteName)!

        defaults.removePersistentDomain(forName: suiteName)

        let store = UserDefaultsRecentSearchStore(
            suiteName: suiteName
        )

        return (store, defaults, suiteName)
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
