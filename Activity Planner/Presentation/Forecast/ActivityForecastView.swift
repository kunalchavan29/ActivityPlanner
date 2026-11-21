//
//  ActivityForecastView.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import SwiftUI

struct ActivityForecastView: View {

    @State private var viewModel: ActivityForecastViewModel
    @Environment(AppCoordinator.self) var coordinator

    init(city: City, forecastService: any ForecastProviding) {
        _viewModel = State(initialValue: ActivityForecastViewModel(city: city, forecastService: forecastService))
    }

    var body: some View {

        Group {
            switch viewModel.state {

            case .idle, .loading:
                loadingView

            case .loaded(let forecasts, let scores):
                dashboard(
                    forecasts: forecasts,
                    scores: scores
                )

            case .empty:
                ContentUnavailableView(
                    "No Forecast Available",
                    systemImage: "cloud",
                    description: Text(
                        "We couldn't find forecast data for this location."
                    )
                )

            case .failed(let message):
                errorView(message)
            }
        }
        .navigationTitle(viewModel.city.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadForecast()
        }
    }

    // MARK: - Loading

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading 7-day forecast...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Dashboard

    private func dashboard(
        forecasts: [DailyForecast],
        scores: [ActivityScore]
    ) -> some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.city.displayName)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Your next 7 days")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("Best days for your activities")
                    .font(.headline)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 12
                ) {
                    ForEach(Activity.allCases) { activity in
                        Button {
                            coordinator.showActivityDetails(activity: activity, dailyForecast: forecasts, scores: scores)
                        } label: {
                            ActivityScoreCard(
                                activity: activity,
                                scores: scores
                            )
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                    }
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text("7-day forecast")
                        .font(.headline)

                    Text("Scores are indicative planning estimates.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(forecasts) { forecast in
                        DailyForecastRow(
                            forecast: forecast,
                            scores: scores
                        )
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {

        ContentUnavailableView {

            Label(
                "Unable to Load Forecast",
                systemImage: "exclamationmark.triangle"
            )

        } description: {

            Text(message)

        } actions: {

            Button("Try Again") {
                Task {
                    await viewModel.retry()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
