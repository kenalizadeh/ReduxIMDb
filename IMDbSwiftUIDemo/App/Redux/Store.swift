//
//  Store.swift
//  IMDbSwiftUIDemo
//
//  Created by Kenan Alizadeh on 11.09.22.
//

import Foundation
import Combine

public class Store<State>: ObservableObject {
    private let _reducer: Reducer<State>
    private let _middlewares: [Middleware<State>]
    private let _queue = DispatchQueue(label: "Store.Queue", qos: .userInitiated)
    private var _subscriptions: Set<AnyCancellable> = []
    private let _actionSubject: PassthroughSubject<Action, Never> = .init()

    @Published
    private(set) var state: State

    public init(
        initial: State,
        reducer: @escaping Reducer<State>,
        middlewares: [Middleware<State>] = []
    ) {
        self.state = initial
        self._reducer = reducer
        self._middlewares = middlewares

        self._setupActionSubscription()
    }

    public func dispatch(_ action: Action) {
        _queue.async {
            self._actionSubject.send(action)
        }
    }

    private func _dispatch(_ action: Action) {
        let newState = self._reducer(state, action)

        self.state = newState
    }

    private func _setupActionSubscription() {
        self._middlewares.reduce(self._actionSubject.eraseToAnyPublisher()) { partialResult, middleware in
            partialResult
                .flatMap { middleware(self.dispatch, self.state, $0) }
                .eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: self._dispatch)
        .store(in: &self._subscriptions)
    }
}
