//
//  StoreTests.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import XCTest

final class StoreTests: XCTestCase {
    func test_createStore() {
        // Given
        // When
        let store: Store<String> = Store(
            initial: "",
            reducer: { state, _ in state },
            middlewares: []
        )

        // Then
        XCTAssertNotNil(store)
    }
}
