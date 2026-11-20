//
//  City.swift
//  Activity Planner

//
//  Created by Kunal on 18/11/26.
//


import Foundation

struct City: Identifiable, Codable, Hashable, Sendable {

    let id: Int
    let name: String
    let country: String
    let region: String?
    let latitude: Double
    let longitude: Double
    let timezone: String?

    var displayName: String {
        if let region, !region.isEmpty {
            return "\(name), \(region), \(country)"
        }

        return "\(name), \(country)"
    }
}
