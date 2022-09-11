//
//  Actions.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias MovieID = String
typealias MovieReviewID = String

enum ISDAction: Action {
    case launch
    case dashboard(ISDDashboardAction)
    case search(ISDSearchAction)
    case movieDetail(ISDMovieDetailAction)
    case movieReview(ISDMovieReviewAction)
}

enum ISDDashboardAction: Action {
    case moviesLoaded(Movies)
    case markMovieViewed(Movie)
    case showError(Error)
}

enum ISDSearchAction: Action {
    case queryUserInput(String)
    case search(String)
    case searchResultsLoaded(Movies)
    case cancelSearch
    case showError(Error)
}

enum ISDMovieDetailAction: Action {
    case viewLoaded(MovieID)
    case movieDetailLoaded(MovieDetail)
    case clear
    case showError(Error)
}

enum ISDMovieReviewAction: Action {
    case viewLoaded(MovieID)
    case movieReviewsLoaded(MovieReviews)
    case tappedReview(MovieReviewID)
    case clear
    case showError(Error)
}
