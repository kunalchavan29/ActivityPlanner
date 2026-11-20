//
//  HomeViewModel.swift
//  Activity Planner
//
//  Created by Kunal on 20/11/26.
//
import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    let searchViewModel: CitySearchViewModel

    private(set) var recentSearches: [City] = []

    private let recentSearchStore: any RecentSearchStoring

    init(
        citySearchService: any CitySearching,
        recentSearchStore: any RecentSearchStoring
    ) {
        self.searchViewModel = CitySearchViewModel(
            citySearchService: citySearchService
        )

        self.recentSearchStore = recentSearchStore
    }

    func loadRecentSearches() async {
        recentSearches = await recentSearchStore.load()
    }

    func selectCity(_ city: City) async {
        recentSearches = await recentSearchStore.save(city)
    }

    func clearRecentSearches() async {
        await recentSearchStore.clear()
        recentSearches = []
    }
}
