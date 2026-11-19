//
//  CitySearching.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//


import Foundation

protocol CitySearching: Sendable {
    func searchCities(matching query: String) async throws -> [City]
}
