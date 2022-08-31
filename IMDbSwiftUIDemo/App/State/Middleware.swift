//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Middleware<State> = (Store<State>, Action) -> AnyPublisher<Action, Never>

let recentlyViewedMoviesMiddleware: Middleware<ISDAppState> = { _, action in
    guard
        let action = action as? ISDAction,
        case let .movieDetail(.movieDetailLoaded(movieDetail)) = action
    else { return Just(action).eraseToAnyPublisher() }

    return Just(ISDAction.dashboard(.markMovieViewed(Movie.init(from: movieDetail))))
        .prepend(action)
        .eraseToAnyPublisher()
}

let loggerMiddleware: Middleware<ISDAppState> = { _, action in
    debugPrint(":LOGGER:", Date(), String(describing: action).prefix(100))

    return Just(action).eraseToAnyPublisher()
}
