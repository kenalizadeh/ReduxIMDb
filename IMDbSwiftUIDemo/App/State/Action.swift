//
//  Action.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

typealias SearchQuery = String

enum ISDAction {
    case launch
    case mainScreen(ISDMainScreenAction)
    case navigate(ISDNavigationAction)
}

enum ISDMainScreenAction {
    case moviesLoaded(Movies)
    case markMovieViewed(Movie)
    case search(SearchQuery)
    case searchResultsLoaded(Movies)
    case clearSearchResults
}

enum ISDNavigationAction {
    case back
    case search(SearchQuery)
    case movieDetail(Movie)
}
