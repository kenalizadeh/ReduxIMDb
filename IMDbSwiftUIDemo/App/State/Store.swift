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
    @Published private(set) var state: State
    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    private let thunks: [Thunk<State, Action>]
    private let queue = DispatchQueue(label: "Store.Queue", qos: .userInitiated)
    private var subscriptions: Set<AnyCancellable> = []

    init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>] = [],
        thunks: [Thunk<State, Action>] = []
    ) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
        self.thunks = thunks
    }

    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }

    private func dispatch(_ currentState: State, _ action: Action) {
        // Middlewares intercept and modify the state if necessary before the action passes to the reducer.
        // TODO: - Write Description
        let newState = middlewares.reduce(into: currentState) { state, middleware in
            state = middleware(state, action)
        }

        // TODO: - Write Description
        let finalState = reducer(newState, action)

        // Thunks handled after the action passes throught the reducer.
        // TODO: - Write Description
        thunks.forEach { thunk in
            thunk(finalState, action)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }

        state = finalState
    }
}
