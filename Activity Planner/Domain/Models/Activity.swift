//
//  City.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//
import Foundation

nonisolated enum Activity: String, CaseIterable, Identifiable, Sendable {

    case skiing
    case surfing
    case outdoorSightseeing
    case indoorSightseeing

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .skiing:
            return "Skiing"

        case .surfing:
            return "Surfing"

        case .outdoorSightseeing:
            return "Outdoor Sightseeing"

        case .indoorSightseeing:
            return "Indoor Sightseeing"
        }
    }

    var symbol: String {
        switch self {
        case .skiing:
            return "figure.skiing.downhill"

        case .surfing:
            return "figure.surfing"

        case .outdoorSightseeing:
            return "sun.max"

        case .indoorSightseeing:
            return "building.2"
        }
    }
}
