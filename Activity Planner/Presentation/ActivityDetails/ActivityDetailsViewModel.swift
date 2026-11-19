//
//  ActivityDetailsViewModel.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class ActivityDetailsViewModel {

    let activity: Activity

    private(set) var rankings: [RankedActivityDay] = []

    init(activity: Activity, forecasts: [DailyForecast], scores: [ActivityScore]) {
        self.activity = activity

        let activityScores = scores.filter {
            $0.activity == activity
        }
        let calendar = Calendar(identifier: .gregorian)
        self.rankings = activityScores.compactMap { score in

            guard let forecast = forecasts.first(where: {
                calendar.isDate($0.date, inSameDayAs: score.date)
            }) else {
                return nil
            }

            return RankedActivityDay(
                score: score,
                forecast: forecast
            )
        }
        .sorted {
            if $0.score.score == $1.score.score {
                return $0.score.date < $1.score.date
            }

            return $0.score.score > $1.score.score
        }
    }

    var bestDay: RankedActivityDay? {
        rankings.first
    }
}

struct RankedActivityDay: Identifiable {

    let score: ActivityScore
    let forecast: DailyForecast

    var id: String {
        score.id
    }
}
