//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Combine

typealias Middleware<State, Action> = (State, Action) -> State

let recentlyViewedMoviesMiddleware: Middleware<ISDAppState, ISDAction> = { state, action in
    guard
        case let .mainScreen(.markMovieViewed(movie)) = action,
        let index = state.dashboard.recentlyViewedMovies.firstIndex(of: movie),
        index != state.dashboard.recentlyViewedMovies.count - 1
    else { return state }

    var state = state

    state.dashboard.recentlyViewedMovies.remove(at: index)

    return state
}

let searchMiddleware: Middleware<ISDAppState, ISDAction> = { state, action in
    guard
        case let .search(.search(text)) = action,
        state.search.searchUserInput.isEmpty
    else { return state }

    var state = state

    state.search.activeSearchQuery = ""

    return state
}
