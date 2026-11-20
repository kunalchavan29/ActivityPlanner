//
//  HomeView.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//



import SwiftUI

struct HomeView: View {

    @State private var viewModel: HomeViewModel
    @State private var navigationPath: [City] = []

    private let forecastService: any ForecastProviding

    init(citySearchService: any CitySearching, forecastService: any ForecastProviding, recentSearchStore: any RecentSearchStoring) {
        self.forecastService = forecastService
        _viewModel = State(initialValue: HomeViewModel(citySearchService: citySearchService, recentSearchStore: recentSearchStore))
    }

    private var searchViewModel: CitySearchViewModel {
        viewModel.searchViewModel
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    header

                    searchBar

                    if searchViewModel.query
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty {
                        recentSearchesSection
                    } else {
                        searchResultsSection
                    }
                }
                .padding()
            }
            .navigationTitle("ActiviyPlanner")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: City.self) { city in
                ActivityForecastView(
                    city: city,
                    forecastService: forecastService
                )
            }
            .task {
                await viewModel.loadRecentSearches()
            }
            .onDisappear {
                searchViewModel.cancelSearch()
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plan your next adventure")
                .font(.title2)
                .fontWeight(.bold)

            Text("Find the best days for outdoor and indoor activities.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search city or town",
                text: Binding(
                    get: { searchViewModel.query },
                    set: { searchViewModel.updateQuery($0) }
                )
            )
            .autocorrectionDisabled()
            .textInputAutocapitalization(.words)

            if !searchViewModel.query.isEmpty {
                Button {
                    searchViewModel.updateQuery("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Recent Searches
    @ViewBuilder
    private var recentSearchesSection: some View {
        if !viewModel.recentSearches.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Recent searches")
                        .font(.headline)

                    Spacer()

                    Button("Clear") {
                        Task {
                            await viewModel.clearRecentSearches()
                        }
                    }
                    .font(.subheadline)
                }

                VStack(spacing: 0) {
                    ForEach(viewModel.recentSearches) { city in
                        Button {
                            openCity(city)
                        } label: {
                            cityRow(city)
                        }
                        .buttonStyle(.plain)

                        if city.id != viewModel.recentSearches.last?.id {
                            Divider()
                                .padding(.leading, 44)
                        }
                    }
                }
            }
        }
    }


    // MARK: - Search Results

    @ViewBuilder
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search results")
                .font(.headline)

            switch searchViewModel.state {
            case .idle:
                EmptyStateView(
                    message: "Start typing to search for a city."
                )

            case .loading:
                ProgressView("Searching cities...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)

            case .results(let cities):
                VStack(spacing: 0) {
                    ForEach(cities) { city in
                        Button {
                            openCity(city)
                        } label: {
                            cityRow(city)
                        }
                        .buttonStyle(.plain)

                        if city.id != cities.last?.id {
                            Divider()
                                .padding(.leading, 44)
                        }
                    }
                }

            case .empty:
                EmptyStateView(
                    message: "No cities found. Try another search."
                )

            case .failed(let message):
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title2)
                        .foregroundStyle(.orange)

                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Try again") {
                        searchViewModel.updateQuery(
                            searchViewModel.query
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
        }
    }

    // MARK: - City Row

    private func cityRow(_ city: City) -> some View {
        HStack(spacing: 12) {
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
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }

    // MARK: - Navigation

    private func openCity(_ city: City) {
        Task {
            await viewModel.selectCity(city)
            searchViewModel.cancelSearch()
            navigationPath.append(city)
        }
    }
}

// MARK: - Empty State

private struct EmptyStateView: View {

    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
    }
}
