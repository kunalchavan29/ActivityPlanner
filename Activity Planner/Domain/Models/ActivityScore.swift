//
//  ActivityScore.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation

struct ActivityScore: Identifiable, Hashable, Sendable {
    let activity: Activity
    let date: Date
    let score: Int
    let explanation: [String]
    var id: String {
        "\(activity.rawValue)-\(date.timeIntervalSince1970)"
    }

    var rating: SuitabilityRating {
        switch score {
        case 80...100:
            return .excellent
        case 60..<80:
            return .good
        case 40..<60:
            return .moderate
        case 20..<40:
            return .poor
        default:
            return .unsuitable
        }
    }
}

enum SuitabilityRating: String, Sendable {
    case excellent
    case good
    case moderate
    case poor
    case unsuitable

    var title: String {
        rawValue.capitalized
    }
}
