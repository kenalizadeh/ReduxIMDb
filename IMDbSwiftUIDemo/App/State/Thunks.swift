//
//  Thunks.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

let mostPopularMoviesThunk: Middleware<ISDAppState> = makeThunk { _, action in
    guard
        let action = action as? ISDAction,
        case .launch = action
    else { return Empty().eraseToAnyPublisher() }

    debugPrint(":LOG: mostPopularMoviesThunk", Date(), String(describing: action).prefix(100))

    return PopularMoviesNetworkService()
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(Movie.init(from:)) }
        .map { ISDAction.dashboard(.moviesLoaded($0)) }
        .catch { Just(ISDAction.dashboard(.showError($0))) }
        .eraseToAnyPublisher()
}

let movieDetailThunk: Middleware<ISDAppState> = makeThunk { _, action in
    guard
        let action = action as? ISDAction,
        case let .movieDetail(.viewLoaded(movieID)) = action
    else { return Empty().eraseToAnyPublisher() }

    debugPrint(":LOG: movieDetailThunk", Date(), String(describing: action).prefix(100))

    return MovieDetailNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ ISDAction.movieDetail(.movieDetailLoaded($0)) })
        .catch { Just(ISDAction.movieDetail(.showError($0))) }
        .eraseToAnyPublisher()
}

let recentlyViewedMoviesThunk: Middleware<ISDAppState> = makeThunk { _, action in
    guard
        let action = action as? ISDAction,
        case let .movieDetail(.movieDetailLoaded(movieDetail)) = action
    else { return Empty().eraseToAnyPublisher() }

    debugPrint(":LOG: recentlyViewedMoviesThunk", Date(), String(describing: action).prefix(100))

    return Just(ISDAction.dashboard(.markMovieViewed(Movie.init(from: movieDetail))))
        .eraseToAnyPublisher()
}

let searchMoviesThunk: Middleware<ISDAppState> = makeThunk { _, action in
    guard
        let action = action as? ISDAction,
        case let .search(.search(query)) = action
    else { return Empty().eraseToAnyPublisher() }

    debugPrint(":LOG: searchMoviesThunk", Date(), String(describing: action).prefix(100))

    return SearchNetworkService(searchQuery: query)
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ ISDAction.search(.searchResultsLoaded($0)) })
        .catch { _ in Empty().eraseToAnyPublisher() }
        .eraseToAnyPublisher()
}

let movieReviewsThunk: Middleware<ISDAppState> = makeThunk { _, action in
    guard
        let action = action as? ISDAction,
        case let .movieReview(.viewLoaded(movieID)) = action
    else { return Empty().eraseToAnyPublisher() }

    debugPrint(":LOG: movieReviewsThunk", Date(), String(describing: action).prefix(100))

    return MovieReviewsNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(MovieReview.init(from:)) }
        .map({ ISDAction.movieReview(.movieReviewsLoaded($0)) })
        .catch { Just(ISDAction.movieReview(.showError($0))) }
        .eraseToAnyPublisher()
}
