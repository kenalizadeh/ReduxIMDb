//
//  Middleware.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let loggerMiddleware: Middleware<ISDAppState, ISDAction> = { _, action in
    let actionLog: String = String(String(describing: action).prefix(100))

    debugPrint(":LOGGER:", Date(), actionLog)

    return Empty().eraseToAnyPublisher()
}
