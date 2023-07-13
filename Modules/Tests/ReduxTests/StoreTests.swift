//
//  StoreTests.swift
//  
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import XCTest
import Redux

final class StoreTests: XCTestCase {

    func test_CreatingAStore() {
        // Given
        // When
        let store: Store<String, String> = Store(initial: "",
                                                 reducer: { state, _ in state },
                                                 middlewares: [])

        // Then
        XCTAssertNotNil(store)
    }
}
