//
//  StoreProjectionTests.swift
//  
//
//  Created by Hugues Telolahy on 08/06/2024.
//

import Combine
import Redux
import XCTest

final class StoreProjectionTests: XCTestCase {
    func testProjectingStore_shouldEmitDerivedState() {
        // Given
        var subscriptions = Set<AnyCancellable>()
        let globalStore: Store<String, Int> = Store(initial: "1") { state, action in
            String(repeating: state, count: action)
        }

        struct MyConector: Connector {
            func deriveState(_ state: String) -> Int? { Int(state) }
            func embedAction(_ action: Int, state: String) -> Int { action }
        }

        let sut = globalStore.projection(using: MyConector())
        var receivedStates: [Int?] = []
        sut.$state.sink { viewState in
            receivedStates.append(viewState)
        }
        .store(in: &subscriptions)

        // When
        sut.dispatch(2)

        // Then
        XCTAssertEqual(receivedStates, [1, 11])
    }
}
