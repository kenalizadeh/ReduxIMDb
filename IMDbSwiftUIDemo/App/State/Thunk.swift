//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

let mostPopularMoviesThunk: Middleware<ISDAppState, ISDAction> = { _, action in
    guard case .launch = action else { return Just(action).eraseToAnyPublisher() }

    let networkService = PopularMoviesNetworkService()

    defer {
        networkService.send()
    }

    return networkService
        .$responseDTO
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(Movie.init(from:)) }
        .map { .dashboard(.moviesLoaded($0)) }
        .prepend(action)
        .eraseToAnyPublisher()
}

let recentlyViewedMoviesThunk: Middleware<ISDAppState, ISDAction> = { _, action in
    guard case let .movieDetail(.movieDetailLoaded(movieDetail)) = action else { return Just(action).eraseToAnyPublisher() }

    return Just(.dashboard(.markMovieViewed(Movie.init(from: movieDetail))))
        .prepend(action)
        .eraseToAnyPublisher()
}

let searchMoviesThunk: Middleware<ISDAppState, ISDAction> = { _, action in
    guard case let .search(.search(query)) = action else { return Just(action).eraseToAnyPublisher() }

    return SearchNetworkService(searchQuery: query)
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ .search(.searchResultsLoaded($0)) })
        .catch({ _ in Empty().eraseToAnyPublisher() })
        .prepend(action)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let movieDetailThunk: Middleware<ISDAppState, ISDAction> = { _, action in
    guard case let .movieDetail(.viewLoaded(movieID)) = action else { return Just(action).eraseToAnyPublisher() }

    return MovieDetailNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ .movieDetail(.movieDetailLoaded($0)) })
        .catch({ Just(.movieDetail(.showError($0))) })
        .prepend([action, .movieDetail(.clear)])
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let movieReviewsThunk: Middleware<ISDAppState, ISDAction> = { _, action in
    guard case let .movieReview(.viewLoaded(movieID)) = action else { return Just(action).eraseToAnyPublisher() }

    return MovieReviewsNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(MovieReview.init(from:)) }
        .map({ .movieReview(.movieReviewsLoaded($0)) })
        .catch({ Just(.movieReview(.showError($0))) })
        .prepend([action, .movieReview(.clear)])
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}
