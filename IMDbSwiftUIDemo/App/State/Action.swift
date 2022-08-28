//
//  Action.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation

typealias SearchQuery = String
typealias MovieID = String
typealias MovieReviewID = String

enum ISDAction {
    case launch
    case dashboard(ISDDashboardAction)
    case search(ISDSearchAction)
    case movieDetail(ISDMovieDetailAction)
    case movieReview(ISDMovieReviewAction)
    case empty
}

enum ISDDashboardAction {
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
    case viewLoaded(MovieID)
    case movieDetailLoaded(MovieDetail)
    case clear
    case showError(Error)
}

enum ISDMovieReviewAction {
    case viewLoaded(MovieID)
    case movieReviewsLoaded(MovieReviews)
    case tappedReview(MovieReviewID)
    case clear
    case showError(Error)
}
