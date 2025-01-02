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
        let store: Store<String, Int, Void> = await Store(initialState: "initial", dependencies: ())

        // Then
        #expect(store != nil)
        await #expect(store.state == "initial")
    }
}
