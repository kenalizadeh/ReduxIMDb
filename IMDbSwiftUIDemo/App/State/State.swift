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
    var movie: Movie?
}

enum ISDScreenState {
    case dashboard(ISDDashboardState)
    case search(SearchQuery)
    case movieDetail
    case showDetail
}
