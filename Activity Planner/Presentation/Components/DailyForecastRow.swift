//
//  DailyForecastRow.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import SwiftUI

struct DailyForecastRow: View {

    let forecast: DailyForecast
    let scores: [ActivityScore]

    private func score(for activity: Activity) -> Int? {
        scores.first {
            $0.activity == activity && $0.date == forecast.date
        }?.score
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(forecast.date.formatted(
                date: .complete,
                time: .omitted
            ))
            .font(.headline)

            HStack(spacing: 8) {
                weatherValue(
                    title: "High",
                    value: forecast.temperatureMax,
                    suffix: "°"
                )

                weatherValue(
                    title: "Low",
                    value: forecast.temperatureMin,
                    suffix: "°"
                )

                weatherValue(
                    title: "Rain",
                    value: forecast.precipitationProbability,
                    suffix: "%"
                )

                weatherValue(
                    title: "Wind",
                    value: forecast.windSpeedMax,
                    suffix: " km/h"
                )
            }

            Divider()

            HStack {
                ForEach(Activity.allCases) { activity in
                    VStack(spacing: 4) {
                        Image(systemName: activity.symbol)
                            .font(.caption)

                        Text(score(for: activity).map(String.init) ?? "—")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func weatherValue(
        title: String,
        value: Double?,
        suffix: String
    ) -> some View {

        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)

            if let value {
                Text("\(Int(value.rounded()))\(suffix)")
                    .font(.caption)
                    .fontWeight(.medium)
            } else {
                Text("—")
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
