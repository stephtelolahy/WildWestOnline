//
//  LoggerTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

import Redux
import Testing

struct LoggerTest {
    @Test func useLoggerReducer() async throws {
        // Given
        let store = await Store<String, Int, Void>(
            initialState: "initial",
            reducer: loggerReducer(),
            dependencies: ()
        )

        // When
        await store.dispatch(1)

        // Then
        await #expect(store.state == "initial")
    }
}
