//
//  MockCitySearchService.swift
//  AppCast
//
//  Created by Kunal on 19/11/26.
//

import Foundation
@testable import Activity_Planner

struct MockCitySearchService: CitySearching {

    var cities: [City] = []
    var shouldThrowError = false

    func searchCities(matching query: String) async throws -> [City] {

        if shouldThrowError {
            throw MockError.searchFailed
        }

        return cities.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
}

enum MockError: LocalizedError {
    case searchFailed
    case forecastFailed

    var errorDescription: String? {
        switch self {
        case .searchFailed:
            return "Mock search failed"
        case .forecastFailed:
            return "Mock forecast failed"
        }
    }
}
