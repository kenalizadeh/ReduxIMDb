//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Middleware<State> = (@escaping (Action) -> (), State, Action) -> AnyPublisher<Action, Never>

let loggerMiddleware: Middleware<ISDAppState> = { _, _, action in
    defer { debugPrint(":LOGGER:", Date(), String(describing: action).prefix(100)) }

    return Just(action).eraseToAnyPublisher()
}

let searchMiddleware: Middleware<ISDAppState> = { _, state, action in
    debugPrint(":LOG: searchMiddleware", Date(), String(describing: action).prefix(100))

    switch action as? ISDAction {
    case let .search(.queryUserInput(text)):
        guard !text.isEmpty else { return Just(ISDAction.search(.cancelSearch)).eraseToAnyPublisher() }

    case let .search(.searchResultsLoaded(movies)):
        guard !state.search.searchUserInput.isEmpty else { return Just(ISDAction.search(.cancelSearch)).eraseToAnyPublisher() }

    case let .search(.search(text)):
        guard !state.search.searchUserInput.isEmpty else { return Just(ISDAction.search(.cancelSearch)).eraseToAnyPublisher() }

    default: break
    }

    return Just(action).eraseToAnyPublisher()
}
