//
//  RecentSearchStoring.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import Foundation

nonisolated protocol RecentSearchStoring: Sendable {
    func load() async -> [City]
    func save(_ city: City) async -> [City]
    func clear() async
}
