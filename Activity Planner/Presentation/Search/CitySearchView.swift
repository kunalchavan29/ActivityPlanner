//
//  CitySearchView.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import SwiftUI

struct CitySearchView: View {

    // MARK: - Properties

    @State private var viewModel: CitySearchViewModel

    @State private var navigationPath: [City] = []

    @FocusState private var isSearchFocused: Bool

    private let onCitySelected: (City) -> Void
    private let forecastService: any ForecastProviding

    // MARK: - Initializer

    init(citySearchService: any CitySearching, forecastService: any ForecastProviding, onCitySelected: @escaping (City) -> Void = { _ in }) {
        _viewModel = State(initialValue: CitySearchViewModel(citySearchService: citySearchService))
        self.forecastService = forecastService
        self.onCitySelected = onCitySelected
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                searchBar
                searchContent
                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("Activity Planner")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: City.self) { city in
                ActivityForecastView(
                    city: city,
                    forecastService: forecastService
                )
            }
            .onDisappear {
                viewModel.cancelSearch()
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {

        HStack(spacing: 12) {

            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search city or town",
                text: Binding(
                    get: { viewModel.query },
                    set: { viewModel.updateQuery($0) }
                )
            )
            .focused($isSearchFocused)
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .submitLabel(.search)

            if !viewModel.query.isEmpty {

                Button {
                    viewModel.updateQuery("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding()
        .background(
            Color.gray.opacity(0.12)
        )
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Search Content

    @ViewBuilder
    private var searchContent: some View {

        switch viewModel.state {

        case .idle:
            idleView

        case .loading:
            loadingView

        case .results(let cities):
            resultsView(cities)

        case .empty:
            emptyView

        case .failed(let message):
            errorView(message)
        }
    }

    // MARK: - Idle State

    private var idleView: some View {

        ContentUnavailableView(
            "Find a destination",
            systemImage: "globe",
            description: Text(
                "Search for a city or town to discover the best days for your favourite activities."
            )
        )
    }

    // MARK: - Loading State

    private var loadingView: some View {

        VStack(spacing: 12) {

            ProgressView()

            Text("Searching cities...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    // MARK: - Results

    private func resultsView(_ cities: [City]) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Search Results")
                .font(.headline)

            ScrollView {

                LazyVStack(spacing: 0) {

                    ForEach(cities) { city in

                        Button {

                            isSearchFocused = false
                            viewModel.cancelSearch()

                            onCitySelected(city)
                            navigationPath.append(city)

                        } label: {

                            cityRow(city)
                        }
                        .buttonStyle(.plain)

                        Divider()
                    }
                }
            }
        }
    }

    // MARK: - City Row

    private func cityRow(_ city: City) -> some View {

        HStack(spacing: 14) {

            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)

            VStack(alignment: .leading, spacing: 4) {

                Text(city.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)

                Text(city.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    // MARK: - Empty State

    private var emptyView: some View {

        ContentUnavailableView.search(
            text: viewModel.query
        )
    }

    // MARK: - Error State

    private func errorView(_ message: String) -> some View {

        ContentUnavailableView {

            Label(
                "Something went wrong",
                systemImage: "exclamationmark.triangle"
            )

        } description: {

            Text(message)

        } actions: {

            Button("Try Again") {
                viewModel.updateQuery(viewModel.query)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
