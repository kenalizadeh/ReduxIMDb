//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

let mostPopularMoviesThunk: Middleware<ISDAppState> = { store, action in
    guard
        let action = action as? ISDAction,
        case .launch = action
    else { return Just(action).eraseToAnyPublisher() }

    return PopularMoviesNetworkService()
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(Movie.init(from:)) }
        .map { ISDAction.dashboard(.moviesLoaded($0)) }
        .catch({ Just(ISDAction.dashboard(.showError($0))) })
        .map { _action in
            store.dispatch(_action)
            return action
        }
        .eraseToAnyPublisher()
}

let searchMoviesThunk: Middleware<ISDAppState> = { store, action in
    guard
        let action = action as? ISDAction,
        case let .search(.search(query)) = action
    else { return Just(action).eraseToAnyPublisher() }

    return SearchNetworkService(searchQuery: query)
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ ISDAction.search(.searchResultsLoaded($0)) })
        .catch({ _ in Empty().eraseToAnyPublisher() })
        .map {
            store.dispatch($0)
            return action
        }
        .eraseToAnyPublisher()
}

let movieDetailThunk: Middleware<ISDAppState> = { store, action in
    guard
        let action = action as? ISDAction,
        case let .movieDetail(.viewLoaded(movieID)) = action
    else { return Just(action).eraseToAnyPublisher() }

    return MovieDetailNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ ISDAction.movieDetail(.movieDetailLoaded($0)) })
        .catch({ Just(ISDAction.movieDetail(.showError($0))) })
        .map {
            store.dispatch($0)
            return action
        }
        .prepend(ISDAction.movieDetail(.clear))
        .eraseToAnyPublisher()
}

let movieReviewsThunk: Middleware<ISDAppState> = { store, action in
    guard
        let action = action as? ISDAction,
        case let .movieReview(.viewLoaded(movieID)) = action
    else { return Just(action).eraseToAnyPublisher() }

    return MovieReviewsNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(MovieReview.init(from:)) }
        .map({ ISDAction.movieReview(.movieReviewsLoaded($0)) })
        .catch({ Just(ISDAction.movieReview(.showError($0))) })
        .map {
            store.dispatch($0)
            return action
        }
        .prepend(ISDAction.movieReview(.clear))
        .eraseToAnyPublisher()
}
