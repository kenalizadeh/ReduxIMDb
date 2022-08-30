//
//  Store.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 14.08.22.
//

import Foundation
import Combine

typealias ISDStore = Store<ISDAppState>

class Store<State>: ObservableObject {
    @Published
    private(set) var state: State
    private let _reducer: Reducer<State>
    private let _middlewares: [Middleware<State>]
    private let _queue = DispatchQueue(label: "Store.Queue", qos: .userInitiated)
    private var _subscriptions: Set<AnyCancellable> = []

    private let _actionSubject: PassthroughSubject<Action, Never> = .init()

    init(
        initial: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>] = []
    ) {
        self.state = initial
        self._reducer = reducer
        self._middlewares = middlewares

        // Middlewares are action pre-processors acting before the root reducer.
        self._middlewares.reduce(_actionSubject.eraseToAnyPublisher()) { partialResult, middleware in
            partialResult
                .flatMap { middleware(self.state, $0) }
                .eraseToAnyPublisher()
        }
        .subscribe(on: _queue)
        .sink(receiveValue: _dispatch)
        .store(in: &_subscriptions)
    }

    func dispatch(_ action: Action) {
        _queue.sync {
            self._actionSubject.send(action)
        }
    }

    private func _dispatch(_ action: Action) {
        // In Redux, a reducer is a pure function that takes the current state and the action to execute as parameters and produces a new state.
        // A pure function is a function that, when given the same inputs, produces the same outputs and has no side effects.
        // A reducer will receive everything that it needs as parameters. It has no ties to any outside entities.
        // It does not change the existing state. It only produces a new State value.
        let newState = _reducer(self.state, action)

        self.state = newState
    }
}
