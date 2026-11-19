//
//  CitySearchViewModel.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class CitySearchViewModel {

    // MARK: - Properties

    private(set) var query = ""

    private(set) var state: CitySearchState = .idle

    private let citySearchService: any CitySearching

    private var searchTask: Task<Void, Never>?

    private let debounceDuration: Duration = .milliseconds(400)

    // MARK: - Initializer

    init(citySearchService: any CitySearching, debounceDuration: Duration = .milliseconds(400)) {
        self.citySearchService = citySearchService
    }

    // MARK: - Search

    func updateQuery(_ newQuery: String) {

        query = newQuery

        // Cancel the previous search task.
        searchTask?.cancel()
        searchTask = nil

        let trimmedQuery = newQuery.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        // Show initial state when query is empty.
        guard !trimmedQuery.isEmpty else {
            state = .idle
            return
        }

        state = .loading

        searchTask = Task {

            do {
                // Debounce: wait before calling the API.
                try await Task.sleep(for: debounceDuration)

                try Task.checkCancellation()

                let cities = try await citySearchService.searchCities(
                    matching: trimmedQuery
                )

                // Ignore outdated or cancelled requests.
                try Task.checkCancellation()

                if cities.isEmpty {
                    state = .empty
                } else {
                    state = .results(cities)
                }

            } catch {

                // Cancellation is expected during typing.
                guard !Task.isCancelled else {
                    return
                }

                state = .failed(error.localizedDescription)
            }
        }
    }

    // MARK: - Cancel

    func cancelSearch() {
        searchTask?.cancel()
        searchTask = nil
    }
}

// MARK: - Search State

enum CitySearchState: Sendable {
    case idle
    case loading
    case results([City])
    case empty
    case failed(String)
}
