//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Combine

typealias Middleware<State, Action> = (State, Action) -> State

let searchMiddleware: Middleware<ISDAppState, ISDAction> = { state, action in
    var state = state

    switch action {
    case .launch:
        break
    case .mainScreen(_):
        break
    case .search(_):
        break
    case .movieDetail(_):
        break
    }

    return state
}
