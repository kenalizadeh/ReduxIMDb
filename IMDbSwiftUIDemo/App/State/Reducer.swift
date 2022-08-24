//
//  Reducer.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let isdReducer: Reducer<ISDAppState, ISDAction> = { state, action in
    var state = state

    switch action {
    case .launch:
        break
    case .mainScreen(let action):
        switch action {
        case .moviesLoaded(let movies):
            state.dashboard.movies = movies

        case .markMovieViewed(let movie):
            guard !state.dashboard.recentlyViewedMovies.contains(movie) else { break }

            state.dashboard.recentlyViewedMovies.append(movie)
        }
    case .search(let action):
        switch action {
        case .queryUserInput(let query):
            state.search.searchUserInput = query

        case .search(let query):
            guard !state.search.searchUserInput.isEmpty else { break }

            state.search.activeSearchQuery = query
            state.search.isSearching = true

        case .searchResultsLoaded(let movies):
            state.search.searchResults = movies
            state.search.isSearching = false

        case .cancelSearch:
            state.search.searchUserInput = ""
            state.search.activeSearchQuery = ""
            state.search.isSearching = false
            state.search.searchResults = []

        case .showError(let error):
            state.search.error = error
        }
    case .movieDetail(let action):
        switch action {
        case .movieDetailLoaded(let movie):
            state.movieDetail.movie = movie
        }
    }

    return state
}
