//
//  MockRecentSearchStore.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import Foundation
@testable import Activity_Planner

actor MockRecentSearchStore: RecentSearchStoring {

    private var cities: [City]

    private(set) var loadCallCount = 0
    private(set) var saveCallCount = 0
    private(set) var clearCallCount = 0

    init(cities: [City] = []) {
        self.cities = cities
    }

    func load() async -> [City] {
        loadCallCount += 1
        return cities
    }

    func save(_ city: City) async -> [City] {
        saveCallCount += 1

        cities.removeAll { $0.id == city.id }
        cities.insert(city, at: 0)
        cities = Array(cities.prefix(10))

        return cities
    }

    func clear() async {
        clearCallCount += 1
        cities.removeAll()
    }

    func storedCities() -> [City] {
        cities
    }

    func callCounts() -> (load: Int, save: Int, clear: Int) {
        (loadCallCount, saveCallCount, clearCallCount)
    }
}
