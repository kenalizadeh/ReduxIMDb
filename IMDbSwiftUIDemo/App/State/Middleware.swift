//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Middleware<State> = (State, Action) -> Action

let loggerMiddleware: Middleware<ISDAppState> = { _, action in
    debugPrint(":LOGGER:", Date(), String(describing: action).prefix(100))

    return action
}

let searchMiddleware: Middleware<ISDAppState> = { state, action in
    switch action as? ISDAction {
    case let .search(.queryUserInput(text)):
        guard !text.isEmpty else { return ISDAction.search(.cancelSearch) }

    case let .search(.searchResultsLoaded(movies)):
        guard !state.search.searchUserInput.isEmpty else { return ISDAction.search(.cancelSearch) }

    case let .search(.search(text)):
        guard !state.search.searchUserInput.isEmpty else { return ISDAction.search(.cancelSearch) }

    default: break
    }

    return action
}
