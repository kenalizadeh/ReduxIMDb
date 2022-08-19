//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 19.08.22.
//

import Foundation
import Combine

typealias Thunk<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let recentlyViewedMoviesThunk: Thunk<ISDAppState, ISDAction> = { _, action in
    if case let .navigate(.movieDetail(movie)) = action {
        return Just(ISDAction.mainScreen(.markMovieViewed(movie)))
            .delay(for: 0.3, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    return Empty().eraseToAnyPublisher()
}
