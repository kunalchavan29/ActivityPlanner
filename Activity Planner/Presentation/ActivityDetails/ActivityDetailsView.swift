//
//  ActivityDetailsView.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//
import SwiftUI

struct ActivityDetailsView: View {

    @State private var viewModel: ActivityDetailsViewModel

    init(activity: Activity, forecasts: [DailyForecast], scores: [ActivityScore]) {
        _viewModel = State(initialValue: ActivityDetailsViewModel(activity: activity, forecasts: forecasts, scores: scores))
    }

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                activityHeader

                if let bestDay = viewModel.bestDay {
                    bestDaySection(bestDay)
                }

                Text("7-day ranking")
                    .font(.title3)
                    .fontWeight(.bold)

                if viewModel.rankings.isEmpty {

                    ContentUnavailableView(
                        "No Ranking Available",
                        systemImage: "chart.bar",
                        description: Text(
                            "There is not enough forecast data to rank this activity."
                        )
                    )

                } else {

                    LazyVStack(spacing: 12) {

                        ForEach(
                            Array(viewModel.rankings.enumerated()),
                            id: \.element.id
                        ) { index, ranking in

                            ActivityRankingRow(
                                ranking: ranking,
                                rank: index + 1
                            )
                        }
                    }
                }

                Text(
                    "Suitability scores are indicative estimates based on forecast weather, not safety recommendations."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(viewModel.activity.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var activityHeader: some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: viewModel.activity.symbol)
                .font(.system(size: 44))
                .foregroundStyle(.blue)

            Text(viewModel.activity.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(
                "Compare the next seven days and find the most suitable weather."
            )
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private func bestDaySection(
        _ ranking: RankedActivityDay
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Label(
                "Recommended day",
                systemImage: "trophy.fill"
            )
            .font(.headline)
            .foregroundStyle(.orange)

            HStack {

                VStack(alignment: .leading, spacing: 5) {

                    Text(ranking.score.date.formatted(
                        date: .complete,
                        time: .omitted
                    ))
                    .font(.title3)
                    .fontWeight(.bold)

                    Text(ranking.score.rating.title)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(ranking.score.score)")
                    .font(.system(size: 38, weight: .bold))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
