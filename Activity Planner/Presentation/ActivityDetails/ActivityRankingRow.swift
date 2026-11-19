//
//  ActivityRankingRow.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import SwiftUI

struct ActivityRankingRow: View {

    let ranking: RankedActivityDay
    let rank: Int

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text("#\(rank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 3) {

                    Text(ranking.score.date.formatted(
                        date: .complete,
                        time: .omitted
                    ))
                    .font(.headline)

                    Text(ranking.score.rating.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if rank == 1 {
                    Label("Best day", systemImage: "trophy.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            ScoreIndicatorView(score: ranking.score.score)

            Divider()

            HStack(spacing: 16) {

                weatherValue(
                    icon: "thermometer.medium",
                    value: ranking.forecast.temperatureMax,
                    suffix: "°"
                )

                weatherValue(
                    icon: "cloud.rain",
                    value: ranking.forecast.precipitationProbability,
                    suffix: "%"
                )

                weatherValue(
                    icon: "wind",
                    value: ranking.forecast.windSpeedMax,
                    suffix: " km/h"
                )

                if let snowfall = ranking.forecast.snowfallAmount {
                    weatherValue(
                        icon: "snowflake",
                        value: snowfall,
                        suffix: " cm"
                    )
                }
            }

            VStack(alignment: .leading, spacing: 6) {

                ForEach(
                    ranking.score.explanation,
                    id: \.self
                ) { explanation in

                    Label(
                        explanation,
                        systemImage: "info.circle"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            rank == 1
                ? Color.green.opacity(0.08)
                : Color(uiColor: .secondarySystemBackground)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func weatherValue(
        icon: String,
        value: Double?,
        suffix: String
    ) -> some View {

        VStack(spacing: 5) {

            Image(systemName: icon)
                .foregroundStyle(.secondary)

            if let value {
                Text("\(Int(value.rounded()))\(suffix)")
                    .font(.caption)
                    .fontWeight(.medium)
            } else {
                Text("—")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
