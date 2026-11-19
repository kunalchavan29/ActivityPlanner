//
//  ActivityScoring.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation

protocol ActivityScoring: Sendable {
    func score(_ forecast: DailyForecast) -> [ActivityScore]
}
