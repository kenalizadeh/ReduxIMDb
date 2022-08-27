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

let searchMoviesThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    guard case let .search(.search(query)) = action else { return Empty().eraseToAnyPublisher() }

    return SearchNetworkService(searchQuery: query)
        .makePublisher()
        .map(\.results)
        .map { $0.map(Movie.init(from:)) }
        .map({ ISDAction.search(.searchResultsLoaded($0)) })
        .catch({ Just(ISDAction.search(.showError($0))) })
        .eraseToAnyPublisher()
}

let movieDetailThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    guard case let .movieDetail(.viewLoaded(movieID)) = action else { return Empty().eraseToAnyPublisher() }

    return MovieDetailNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(MovieDetail.init(from:))
        .map({ ISDAction.movieDetail(.movieDetailLoaded($0)) })
        .catch({ Just(ISDAction.movieDetail(.showError($0))) })
        .eraseToAnyPublisher()
}

let movieReviewsThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    guard case let .movieReview(.viewLoaded(movieID)) = action else { return Empty().eraseToAnyPublisher() }

    return MovieReviewsNetworkService(movieID: movieID)
        .makePublisher()
        .compactMap { $0 }
        .map(\.items)
        .map { $0.map(MovieReview.init(from:)) }
        .map({ ISDAction.movieReview(.movieReviewsLoaded($0)) })
        .catch({ Just(ISDAction.movieReview(.showError($0))) })
        .eraseToAnyPublisher()
}

let loggerThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    let actionLog: String = String(String(describing: action).prefix(100))

    debugPrint(":LOG:", actionLog)

    return Empty().eraseToAnyPublisher()
}

// MARK: - Mock Thunks

let mockMovieDetailThunk: Thunk<ISDAppState, ISDAction> = { state, action in
    guard case let .movieDetail(.viewLoaded(movieID)) = action else { return Empty().eraseToAnyPublisher() }

    guard let movie = state.dashboard.movies.randomElement() else { return Empty().eraseToAnyPublisher() }

    let mockMovie = MovieDetail(id: movie.id, title: movie.title, originalTitle: movie.fullTitle, fullTitle: movie.fullTitle, year: "", image: movie.imageURL, releaseDate: "", runtimeStr: "", plotLocal: "", directors: [], writers: [], stars: "", actors: [], genres: "", similarMovies: [], imageURLs: [])

    return Just(ISDAction.movieDetail(.movieDetailLoaded(mockMovie)))
        .delay(for: 1.4, scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
}
