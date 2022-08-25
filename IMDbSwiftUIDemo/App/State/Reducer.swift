//
//  Reducer.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let isdReducer: Reducer<ISDAppState, ISDAction> = { state, action in
    defer { print(":LOG:", String(String(describing: action).prefix(100))) }
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
            guard !state.search.searchUserInput.isEmpty else { break }

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
        case .viewLoaded(let movieID):
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

    case .movieReview(let action):
        switch action {
        case .viewLoaded(let movieID):
            state.movieReviews.movieID = movieID
            state.movieReviews.isLoading = true

        case .movieReviewsLoaded(let reviews):
            state.movieReviews.reviews = reviews
            state.movieReviews.isLoading = false

        case .tappedReview(let reviewID):
            state.movieReviews.expandedMovieReviewID = state.movieReviews.expandedMovieReviewID == reviewID ? "" : reviewID

        case .clear:
            state.movieReviews = .init()

        case .showError(let error):
            state.movieReviews.error = error
            state.movieReviews.isLoading = false
        }
    }

    return state
}
