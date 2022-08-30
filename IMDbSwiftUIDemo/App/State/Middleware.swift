//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Middleware<State> = (State, Action) -> AnyPublisher<Action, Never>

let loggerMiddleware: Middleware<ISDAppState> = { _, action in
    debugPrint(":LOGGER:", Date(), String(describing: action).prefix(100))

    return Just(action).eraseToAnyPublisher()
}
