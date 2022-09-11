//
//  Thunk.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Combine

public func makeThunk<State>(_ body: @escaping (State, Action) -> AnyPublisher<Action, Never>) -> Middleware<State> {
    return { dispatch, state, action in
        body(state, action)
            .flatMap { action -> AnyPublisher<Action, Never> in
                dispatch(action)

                return Empty()
                    .eraseToAnyPublisher()
            }
            .prepend(action)
            .eraseToAnyPublisher()
    }
}
