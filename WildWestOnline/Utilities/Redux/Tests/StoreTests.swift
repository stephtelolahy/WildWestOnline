//
//  StoreTests.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import XCTest

final class StoreTests: XCTestCase {
    func test_createStore() throws {
        // Given
        // When
        let store: Store<String> = Store(initial: "initial")

        // Then
        XCTAssertNotNil(store)
        XCTAssertEqual(store.state, "initial")
    }
}
