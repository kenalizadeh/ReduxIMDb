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

        self._middlewares.reduce(_actionSubject.eraseToAnyPublisher()) { partialResult, middleware in
            partialResult
                .flatMap { action in
//                    if let _action = action as? Thunk<State> {
//                        _action.body(self.state)
//                            .sink(receiveValue: self.dispatch)
//                            .store(in: &self._subscriptions)
//                        return Just(action).eraseToAnyPublisher()
//                    } else {
                        return middleware(self.dispatch, self.state, action)
//                    }
                }
                .eraseToAnyPublisher()
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: _dispatch)
        .store(in: &_subscriptions)
    }

    func dispatch(_ action: Action) {
        _queue.async {
            debugPrint(":LOG: dispatch", Date(), String(describing: action).prefix(100))
            self._actionSubject.send(action)
        }
    }

    private func _dispatch(_ action: Action) {
        debugPrint(":LOG: reducer phase", Date(), String(describing: action).prefix(100))
        let newState = _reducer(state, action)

        state = newState
    }
}
