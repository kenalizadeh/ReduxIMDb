//
//  State.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

struct ISDAppState {
    var dashboard: ISDDashboardState = .init()
    var movieDetail: ISDMovieDetailState = .init()
    var search: ISDSearchState = .idle
}

enum ISDSearchState {
    case idle
    case ready(Movies)
    case searching(SearchQuery)
}

struct ISDDashboardState {
    var movies: Pages<Movie> = .init()
    var recentlyViewedMovies: Movies = []
    var searchQuery: String = ""
}

struct ISDMovieDetailState {
    var movie: Movie?
}

enum ISDScreenState {
    case dashboard(ISDDashboardState)
    case search(SearchQuery)
    case movieDetail
    case showDetail
}
