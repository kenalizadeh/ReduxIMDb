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

    case .mainScreen(let mainScreenAction):
        switch mainScreenAction {
        case .moviesLoaded(let movies):
            state.dashboard.movies.addPage(totalPages: 5, values: movies)

        case .markMovieViewed(let movie):
            guard !state.dashboard.recentlyViewedMovies.contains(movie) else { break }

            state.dashboard.recentlyViewedMovies.append(movie)

        case .searchResultsLoaded(let movies):
            state.search = .ready(movies)

        case .clearSearchResults:
            state.search = .idle

        default: break
        }
    case .navigate(let navigationAction):
        switch navigationAction {
        case .back:
            break

        case .search(let query):
            state.search = .searching(query)

        case .movieDetail(let movieID):
            break
        }
    }

    return state
}
