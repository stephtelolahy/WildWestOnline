//
//  StoreDispatchTest.swift
//
//  Created by Hugues Telolahy on 29/09/2026.
//

import Testing
import Redux

@MainActor
struct StoreDispatchTest {
    @Test func dispatchGroupedEffects_shouldHandleActionsDepthFirst() async throws {
        // Given
        let sut = Store<[String], String>(
            initialState: [],
            reducer: { state, action, _ in
                state.append(action)
                switch action {
                case "root":
                    return .group([
                        .send("a"),
                        .run { "b" },
                        .group([.send("c"), .none])
                    ])

                case "a":
                    return .send("a1")

                case "a1":
                    return .run { "a2" }

                default:
                    return .none
                }
            }
        )

        // When
        let received = await sut.receive("root")

        // Then
        #expect(received == ["a", "a1", "a2", "b", "c"])
        #expect(sut.state == ["root", "a", "a1", "a2", "b", "c"])
    }

    @Test func dispatchLongChainOfActions_shouldCompleteAllOfThem() async throws {
        // Given
        let count = 10_000
        let sut = Store<Int, Int>(
            initialState: 0,
            reducer: { state, action, _ in
                state = action
                return action < count ? .send(action + 1) : .none
            }
        )

        // When
        await sut.dispatch(0)

        // Then
        #expect(sut.state == count)
    }
}
