//
//  StoreTests.swift
//  IMDbSwiftUIDemoTests
//
//  Created by Kenan Alizadeh on 30.08.22.
//

import XCTest
@testable
import IMDbSwiftUIDemo
import Combine

enum FakeAction: Action {
    case custom(String)
}

struct FakeState {
    var val: String = ""
}

let fakeReducer: Reducer<FakeState> = { state, action in
    guard let action = action as? FakeAction, case let .custom(val) = action else { return state }

    var state = state

    state.val = val

    return state
}

let middleWare1: Middleware<FakeState> = { state, action in
    guard let action = action as? FakeAction, case let .custom(val) = action else { return Just(action).eraseToAnyPublisher() }

    let newVal = val + " middleWare1"

    return Just(FakeAction.custom(newVal)).eraseToAnyPublisher()
}

let middleWare2: Middleware<FakeState> = { state, action in
    guard let action = action as? FakeAction, case let .custom(val) = action else { return Just(action).eraseToAnyPublisher() }

    let newVal = val + " middleWare2"

    return Just(FakeAction.custom(newVal)).eraseToAnyPublisher()
}

let middleWare3: Middleware<FakeState> = { state, action in
    guard let action = action as? FakeAction, case let .custom(val) = action else { return Just(action).eraseToAnyPublisher() }

    let newVal = val + " middleWare3"

    return Just(FakeAction.custom(newVal)).eraseToAnyPublisher()
}

final class StoreTests: XCTestCase {
    let fakeStore = Store<FakeState>(
        initial: .init(),
        reducer: fakeReducer,
        middlewares: [
            middleWare1,
            middleWare2,
            middleWare3
        ]
    )

    func testExample() throws {
        fakeStore.dispatch(FakeAction.custom("action"))

        XCTAssertFalse(fakeStore.state.val.isEmpty)

        let exp = expectation(description: "Test after 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 5.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertFalse(fakeStore.state.val.isEmpty)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
