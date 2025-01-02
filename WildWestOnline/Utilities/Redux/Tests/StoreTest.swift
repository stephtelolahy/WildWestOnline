//
//  StoreTest.swift
//
//
//  Created by Hugues Telolahy on 07/04/2023.
//

import Redux
import Testing

struct StoreTest {
    @Test func createStore() async throws {
        // Given
        // When
        let store: Store<String> = Store(initial: "initial")

        // Then
        #expect(store != nil)
        #expect(store.state == "initial")
    }
}
