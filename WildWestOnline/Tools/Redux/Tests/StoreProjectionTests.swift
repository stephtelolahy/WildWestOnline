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

    func testExplore() {
        // Given
        var subscriptions = Set<AnyCancellable>()
        let globalStore: Store<String, Int> = Store(initial: "1") { state, action in
            String(repeating: state, count: action)
        }
        let deriveState: (String) -> Int? = { Int($0) }
        let embedAction: (Int) -> Int = { $0 }

        let sut = globalStore.projection(deriveState: deriveState, embedAction: embedAction)
        var receivedStates: [Int?] = []
        sut.$state.sink { viewState in
            receivedStates.append(viewState)
        }
        .store(in: &subscriptions)


        // When
        sut.dispatch(2)

        // Then
        XCTAssertEqual(receivedStates, [11])
    }

}
