//
//  Store.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias ISDStore = Store<ISDAppState, ISDAction>

class Store<State, Action>: ObservableObject {
    @Published
    private(set) var state: State
    private let _reducer: Reducer<State, Action>
    private let _middlewares: [Middleware<State, Action>]
    private let _queue = DispatchQueue(label: "Store.Queue", qos: .userInitiated)
    private var _subscriptions: Set<AnyCancellable> = []

    init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = initial
        self._reducer = reducer
        self._middlewares = middlewares
    }

    func dispatch(_ action: Action) {
        _queue.sync {
            self._dispatch(self.state, action)
        }
    }

    private func _dispatch(_ currentState: State, _ action: Action) {
        // Middlewares are action pre-processors acting before the root reducer.
        _middlewares.forEach { middleware in
            middleware(currentState, action)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &_subscriptions)
        }

        // In Redux, a reducer is a pure function that takes the current state and the action to execute as parameters and produces a new state.
        // A pure function is a function that, when given the same inputs, produces the same outputs and has no side effects.
        // A reducer will receive everything that it needs as parameters. It has no ties to any outside entities.
        // It does not change the existing state. It only produces a new State value.
        let newState = _reducer(currentState, action)

        self.state = newState
    }
}
