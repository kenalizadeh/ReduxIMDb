//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

let mostPopularMoviesThunk: Middleware<ISDAppState> = { _, action in
    guard let action = action as? ISDAction else { return Just(action).eraseToAnyPublisher() }

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
        .map { ISDAction.dashboard(.moviesLoaded($0)) }
        .prepend(action)
        .eraseToAnyPublisher()
}

let recentlyViewedMoviesThunk: Middleware<ISDAppState> = { _, action in
    guard let action = action as? ISDAction else { return Just(action).eraseToAnyPublisher() }

    guard case let .movieDetail(.movieDetailLoaded(movieDetail)) = action else { return Just(action).eraseToAnyPublisher() }

    return Just(ISDAction.dashboard(.markMovieViewed(Movie.init(from: movieDetail))))
        .prepend(action)
        .eraseToAnyPublisher()
}

let searchMoviesThunk: Middleware<ISDAppState> = { _, action in
    guard let action = action as? ISDAction else { return Just(action).eraseToAnyPublisher() }

    guard case let .search(.search(query)) = action else { return Just(action).eraseToAnyPublisher() }

    return SearchNetworkService(searchQuery: query)
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ ISDAction.search(.searchResultsLoaded($0)) })
        .catch({ _ in Empty().eraseToAnyPublisher() })
        .prepend(action)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let movieDetailThunk: Middleware<ISDAppState> = { _, action in
    guard let action = action as? ISDAction else { return Just(action).eraseToAnyPublisher() }

    guard case let .movieDetail(.viewLoaded(movieID)) = action else { return Just(action).eraseToAnyPublisher() }

    return MovieDetailNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ ISDAction.movieDetail(.movieDetailLoaded($0)) })
        .catch({ Just(ISDAction.movieDetail(.showError($0))) })
        .prepend([action, ISDAction.movieDetail(.clear)])
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}

let movieReviewsThunk: Middleware<ISDAppState> = { _, action in
    guard let action = action as? ISDAction else { return Just(action).eraseToAnyPublisher() }

    guard case let .movieReview(.viewLoaded(movieID)) = action else { return Just(action).eraseToAnyPublisher() }

    return MovieReviewsNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(MovieReview.init(from:)) }
        .map({ ISDAction.movieReview(.movieReviewsLoaded($0)) })
        .catch({ Just(ISDAction.movieReview(.showError($0))) })
        .prepend([action, ISDAction.movieReview(.clear)])
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
}
