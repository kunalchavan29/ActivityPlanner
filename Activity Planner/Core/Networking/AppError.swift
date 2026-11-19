//
//  AppError.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

enum AppError: LocalizedError {

    case featureNotImplemented(String)
    case invalidResponse
    case networkError(String)

    var errorDescription: String? {

        switch self {

        case .featureNotImplemented(let feature):
            return "\(feature) is not implemented yet."

        case .invalidResponse:
            return "The server returned an invalid response."

        case .networkError(let message):
            return message
        }
    }
}
