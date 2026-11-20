//
//  UserDefaultsRecentSearchStore.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import Foundation

actor UserDefaultsRecentSearchStore: RecentSearchStoring {
    // MARK: - Properties
    private nonisolated(unsafe) let defaults: UserDefaults
    private let storageKey = "activityPlanner.recentSearches"
    private let maximumRecentSearches = 10

    // In-memory cache
    private var recentSearches: [City]

    // MARK: - Initializer

    init(suiteName: String? = nil) {
        let storage = suiteName.flatMap {
            UserDefaults(suiteName: $0)
        } ?? .standard
        
        self.defaults = storage
        
        if let data = storage.data(forKey: storageKey),
           let cities = try? JSONDecoder().decode([City].self, from: data) {
            self.recentSearches = Array(cities.prefix(10))
        } else {
            self.recentSearches = []
        }
    }

    // MARK: - Load

    func load() async -> [City] {
        recentSearches
    }

    // MARK: - Save
    func save(_ city: City) async -> [City] {

        // Remove duplicate.
        recentSearches.removeAll {
            $0.id == city.id
        }

        // Insert at the beginning.
        recentSearches.insert(city, at: 0)

        // Maintain maximum limit.
        recentSearches = Array(
            recentSearches.prefix(maximumRecentSearches)
        )

        // Persist the updated snapshot.
        persist()

        return recentSearches
    }

    // MARK: - Clear

    func clear() async {
        recentSearches.removeAll()
        defaults.removeObject(forKey: storageKey)
    }

    // MARK: - Persistence

    private func persist() {
        guard let data = try? JSONEncoder().encode(recentSearches) else {
            return
        }

        defaults.set(data, forKey: storageKey)
    }
}
