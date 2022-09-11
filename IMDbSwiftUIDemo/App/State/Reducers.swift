//
//  Reducers.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

let rootReducer: Reducer<ISDAppState> = { state, action in
    ISDAppState(
        dashboard: dashboardReducer(state.dashboard, action),
        movieDetail: movieDetailReducer(state.movieDetail, action),
        movieReviews: movieReviewReducer(state.movieReviews, action),
        search: searchReducer(state.search, action)
    )
}

let dashboardReducer: Reducer<ISDDashboardState> = { state, action in
    guard case let ISDAction.dashboard(action) = action else { return state }

    var state = state

    switch action {
    case .moviesLoaded(let movies):
        state.movies = movies

    case .markMovieViewed(let movie):
        if let index = state.recentlyViewedMovies.firstIndex(of: movie) {
            state.recentlyViewedMovies.remove(at: index)
        }

        state.recentlyViewedMovies.append(movie)

    case .showError(let error):
        state.error = error
        state.isLoading = false
    }

    return state
}

let movieDetailReducer: Reducer<ISDMovieDetailState> = { state, action in
    guard case let ISDAction.movieDetail(action) = action else { return state }

    var state = state

    switch action {
    case .viewLoaded(let movieID):
        state.movieID = movieID
        state.isLoading = true

    case .movieDetailLoaded(let movie):
        state.movie = movie
        state.isLoading = false

    case .clear:
        state = .init()

    case .showError(let error):
        state.error = error
        state.isLoading = false
    }

    return state
}

let movieReviewReducer: Reducer<ISDMovieReviewState> = { state, action in
    guard case let ISDAction.movieReview(action) = action else { return state }

    var state = state

    switch action {
    case .viewLoaded(let movieID):
        state.movieID = movieID
        state.isLoading = true

    case .movieReviewsLoaded(let reviews):
        state.reviews = reviews
        state.isLoading = false

    case .tappedReview(let reviewID):
        state.expandedMovieReviewID = state.expandedMovieReviewID == reviewID ? "" : reviewID

    case .clear:
        state = .init()

    case .showError(let error):
        state.error = error
        state.isLoading = false
    }

    return state
}

let searchReducer: Reducer<ISDSearchState> = { state, action in
    guard case let ISDAction.search(action) = action else { return state }

    var state = state

    switch action {
    case .queryUserInput(let query):
        state.searchUserInput = query

    case .search(let query):
        state.error = nil
        state.activeSearchQuery = query
        state.isSearching = true

    case .searchResultsLoaded(let movies):
        state.error = nil
        state.searchResults = movies
        state.isSearching = false

    case .cancelSearch:
        state = .init()

    case .showError(let error):
        state.error = error
    }

    return state
}
