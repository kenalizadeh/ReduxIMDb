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

            state.search.error = nil
            state.search.activeSearchQuery = query
            state.search.isSearching = true

        case .searchResultsLoaded(let movies):
            state.search.error = nil
            state.search.searchResults = movies
            state.search.isSearching = false

        case .cancelSearch:
            state.search = .init()

        case .showError(let error):
            state.search.error = error
        }
    case .movieDetail(let action):
        switch action {
        case .fetchData(let movieID):
            state.movieDetail.movieID = movieID
            state.movieDetail.isLoading = true

        case .movieDetailLoaded(let movie):
            state.movieDetail.movie = movie
            state.movieDetail.isLoading = false

        case .clear:
            state.movieDetail = .init()

        case .showError(let error):
            state.movieDetail.error = error
            state.movieDetail.isLoading = false
        }
    }

    return state
}
