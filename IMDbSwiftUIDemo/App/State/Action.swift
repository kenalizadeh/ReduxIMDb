//
//  Action.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

typealias SearchQuery = String
typealias MovieID = String

enum ISDAction {
    case launch
    case mainScreen(ISDMainScreenAction)
    case search(ISDSearchAction)
    case movieDetail(ISDMovieDetailAction)
}

enum ISDMainScreenAction {
    case moviesLoaded(Movies)
    case markMovieViewed(Movie)
}

enum ISDSearchAction {
    case queryUserInput(SearchQuery)
    case search(SearchQuery)
    case searchResultsLoaded(Movies)
    case cancelSearch
    case showError(Error)
}

enum ISDMovieDetailAction {
    case fetchData(MovieID)
    case movieDetailLoaded(MovieDetail)
    case clear
    case showError(Error)
}
