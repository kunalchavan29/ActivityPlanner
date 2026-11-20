//
//  DailyForecast.swift
//  Activity Planner
//
//  Created by Kunal on 18/11/26.
//


import Foundation

nonisolated struct DailyForecast: Identifiable, Hashable, Sendable {

    let date: Date

    let temperatureMax: Double?
    let temperatureMin: Double?

    let precipitationProbability: Double?
    let precipitationAmount: Double?

    let snowfallAmount: Double?

    let windSpeedMax: Double?

    let sunshineDuration: Double?

    let weatherCode: Int?

    var id: Date {
        date
    }
}
