//
//  GeocodingResponse.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

nonisolated struct GeocodingResponse: Decodable, Sendable {
    let results: [GeocodingResult]?
}

nonisolated struct GeocodingResult: Decodable, Sendable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let admin1: String?
    let timezone: String?

    func toDomain() -> City {
        City(
            id: id,
            name: name,
            country: country,
            region: admin1,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone
        )
    }
}
