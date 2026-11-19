//
//  ForecastProviding.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//
import Foundation

protocol ForecastProviding: Sendable {
    func fetchForecast(for city: City) async throws -> [DailyForecast]
}
