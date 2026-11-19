//
//  OpenMeteoLocationRepository.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

struct OpenMeteoLocationRepository: CitySearching {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func searchCities(
        matching query: String
    ) async throws -> [City] {

        let trimmedQuery = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmedQuery.isEmpty else {
            return []
        }

        let response: GeocodingResponse = try await apiClient.request(
            .geocoding(query: trimmedQuery)
        )

        return response.results?.map {
            $0.toDomain()
        } ?? []
    }
}
