//
//  LoggerTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/01/2025.
//

import Redux
import Testing

struct LoggerTest {
    @Test func useLoggerReducer_shouldPrintAction() async throws {
        // Given
        let sut = await Store<String, Int, Void>(
            initialState: "initial",
            reducer: loggerReducer(),
            dependencies: ()
        )

        // When
        await sut.dispatch(1)

        // Then
        await #expect(sut.state == "initial")
    }
}
