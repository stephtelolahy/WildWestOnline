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
        let store: StoreV1<String> = StoreV1(initial: "initial")

        // Then
        XCTAssertNotNil(store)
        XCTAssertEqual(store.state, "initial")
    }
}
