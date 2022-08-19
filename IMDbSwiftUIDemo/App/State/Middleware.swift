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
    case .mainScreen(let mainScreenAction):
        break
    case .navigate(let navigationAction):
        switch navigationAction {
        case .back:
            break
        case .search(let query):
            break
        case .movieDetail(let movie):
            break
        }
    }

    return state
}
