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
        case .search(let query):
            state.search = .searching(query)

        case .searchResultsLoaded(let movies):
            state.search = .ready(movies)

        case .clearSearchResults:
            state.search = .idle
        }
    case .movieDetail(let action):
        switch action {
        case .movieDetailLoaded(let movie):
            state.movieDetail.movie = movie
        }
    }

    return state
}
