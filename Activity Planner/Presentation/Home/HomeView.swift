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

    init(
        citySearchService: any CitySearching,
        forecastService: any ForecastProviding,
        recentSearchStore: any RecentSearchStoring
    ) {
        self.forecastService = forecastService

        _viewModel = State(
            initialValue: HomeViewModel(
                citySearchService: citySearchService,
                recentSearchStore: recentSearchStore
            )
        )
    }

    private var searchViewModel: CitySearchViewModel {
        viewModel.searchViewModel
    }

    private var hasSearchQuery: Bool {
        !searchViewModel.query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HomeHeroView()

                    searchBar
                        .padding(.horizontal, 20)
                        .padding(.top, -48)
                        .padding(.bottom, -48)

                    if hasSearchQuery {
                        searchResultsSection
                            .padding(.horizontal, 20)
                    } else {
                        recentSearchesSection
                            .padding(.horizontal, 20)

                        HomeWelcomeView()
                    }
                }
                .padding(.bottom, 32)
            }
            .background(ActivityPlannerStyle.screenBackground)
            .ignoresSafeArea(edges: .top)
            .toolbar(.hidden, for: .navigationBar)
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
        .tint(ActivityPlannerStyle.accent)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        ActivityPlannerSearchBar(
            query: Binding(
                get: { searchViewModel.query },
                set: { searchViewModel.updateQuery($0) }
            )
        )
    }

    // MARK: - Recent Searches

    @ViewBuilder
    private var recentSearchesSection: some View {
        if !viewModel.recentSearches.isEmpty {
            VStack(spacing: 16) {
                ActivityPlannerSectionHeader(
                    title: "Recent searches",
                    symbol: "clock.arrow.circlepath",
                    actionTitle: "Clear"
                ) {
                    Task {
                        await viewModel.clearRecentSearches()
                    }
                }

                VStack(spacing: 0) {
                    ForEach(
                        Array(viewModel.recentSearches.enumerated()),
                        id: \.element.id
                    ) { index, city in
                        Button {
                            openCity(city)
                        } label: {
                            CityRowView(city: city)
                        }
                        .buttonStyle(.plain)

                        if index < viewModel.recentSearches.count - 1 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }
                }
            }
            .activityPlannerCard()
        }
    }

    // MARK: - Search Results

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search results")
                .font(.headline)

            VStack(spacing: 0) {
                switch searchViewModel.state {
                case .idle:
                    ActivityPlannerEmptyState(
                        symbol: "magnifyingglass",
                        title: "Find a destination",
                        message: "Start typing a city name."
                    )

                case .loading:
                    ProgressView("Finding cities...")
                        .frame(maxWidth: .infinity)
                        .padding(35)

                case .results(let cities):
                    ForEach(Array(cities.enumerated()), id: \.element.id) {
                        index, city in

                        Button {
                            openCity(city)
                        } label: {
                            CityRowView(city: city)
                        }
                        .buttonStyle(.plain)

                        if index < cities.count - 1 {
                            Divider()
                                .padding(.leading, 60)
                        }
                    }

                case .empty:
                    ActivityPlannerEmptyState(
                        symbol: "map",
                        title: "No cities found",
                        message: "Try another city or check the spelling."
                    )

                case .failed(let message):
                    VStack(spacing: 12) {
                        ActivityPlannerEmptyState(
                            symbol: "wifi.exclamationmark",
                            title: "Something went wrong",
                            message: message
                        )

                        Button("Try again") {
                            searchViewModel.updateQuery(
                                searchViewModel.query
                            )
                        }
                    }
                }
            }
            .activityPlannerCard()
        }
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
