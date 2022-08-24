//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

typealias Thunk<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let mostPopularMoviesThunk: Thunk<ISDAppState, ISDAction> = { state, action in
    guard case .launch = action else { return Empty().eraseToAnyPublisher() }

    let networkService = PopularMoviesNetworkService()

    defer {
        networkService.send()
    }

    return networkService
        .$responseDTO
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(Movie.init(from:)) }
        .map { ISDAction.mainScreen(.moviesLoaded($0)) }
        .eraseToAnyPublisher()
}

let recentlyViewedMoviesThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    if case let .movieDetail(.movieDetailLoaded(movieDetail)) = action {
        return Just(ISDAction.mainScreen(.markMovieViewed(Movie.init(from: movieDetail))))
            .eraseToAnyPublisher()
    }

    return Empty().eraseToAnyPublisher()
}

let searchMoviesThunk: Thunk<ISDAppState, ISDAction> = { state, action in
    guard case let .search(.search(query)) = action else { return Empty().eraseToAnyPublisher() }

    let networkService = SearchNetworkService(searchQuery: query)

    defer {
        networkService.send()
    }

    return networkService
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ ISDAction.search(.searchResultsLoaded($0)) })
        .catch({ Just(ISDAction.search(.showError($0))) })
        .eraseToAnyPublisher()
}

let movieDetailThunk: Thunk<ISDAppState, ISDAction> = { state, action in
    guard case let .movieDetail(.fetchData(movieID)) = action else { return Empty().eraseToAnyPublisher() }

    let networkService = MovieDetailNetworkService(movieID: movieID)

    defer {
        networkService.send()
    }

    return networkService
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ ISDAction.movieDetail(.movieDetailLoaded($0)) })
        .catch({ Just(ISDAction.movieDetail(.showError($0))) })
        .eraseToAnyPublisher()
}
