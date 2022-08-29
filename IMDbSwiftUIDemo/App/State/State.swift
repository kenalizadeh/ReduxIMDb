//
//  State.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

struct ISDAppState {
    var dashboard: ISDDashboardState = .init()
    var movieDetail: ISDMovieDetailState = .init()
    var movieReviews: ISDMovieReviewState = .init()
    var search: ISDSearchState = .init()
}

struct ISDSearchState {
    var isSearching: Bool = false
    var searchUserInput: String = ""
    var activeSearchQuery: String = ""
    var searchResults: Movies = []
    var error: Error? = nil
}

struct ISDDashboardState {
    var movies: Movies = []
    var recentlyViewedMovies: Movies = []
}

struct ISDMovieDetailState {
    var movieID: MovieID? = nil
    var movie: MovieDetail? = nil
    var isLoading: Bool = false
    var error: Error? = nil
}

struct ISDMovieReviewState {
    var movieID: MovieID? = nil
    var reviews: MovieReviews = []
    var expandedMovieReviewID: MovieReviewID? = nil
    var isLoading: Bool = false
    var error: Error? = nil
}

enum ISDScreenState {
    case dashboard(ISDDashboardState)
    case search(String)
    case movieDetail
    case showDetail
}
