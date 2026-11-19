//
//  APIError.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case emptyResponse

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Invalid API URL."

        case .invalidResponse:
            return "Invalid server response."

        case .httpError(let statusCode):
            return "Server returned HTTP status \(statusCode)."

        case .decodingError:
            return "Unable to process server response."

        case .emptyResponse:
            return "No data available."
        }
    }
}
