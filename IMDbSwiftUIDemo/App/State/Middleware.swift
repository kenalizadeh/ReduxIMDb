//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Combine

typealias Middleware<State, Action> = (State, Action) -> State

let searchMiddleware: Middleware<ISDAppState, ISDAction> = { state, action in
    guard case let .search(.search(text)) = action else { return state }

    var state = state

    if state.search.searchUserInput.isEmpty {
        state.search.activeSearchQuery = ""
    }

    return state
}
