//
//  WillyTheKidTest.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Testing
import GameFeature

struct WillyTheKidTest {
    @Test func shouldPlayBangIgnoringLimitPerTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.willyTheKid])
                    .withHand([.bang2])
                    .withWeapon(1)
            }
            .withPlayer("p2")
            .withEvents([
                .equip(.barrel, player: "p1"),
                .play(.bang1, player: "p1"),
                .startTurn(player: "p1"),
            ])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang2, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.bang2, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.bang2, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }

    @Test func equipedWithVolcanic_shouldPlayBangIgnoringLimitPerTurn() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1") {
                $0.withFigure([.willyTheKid])
                    .withHand([.bang2])
                    .withWeapon(1)
                    .withInPlay([.volcanic])
            }
            .withPlayer("p2")
            .withEvents([
                .equip(.barrel, player: "p1"),
                .play(.bang1, player: "p1"),
                .startTurn(player: "p1"),
            ])
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang2, player: "p1")
        let result = try await dispatchUntilCompleted(action, state: state)

        // Then
        #expect(result == [
            .preparePlay(.bang2, player: "p1"),
            .choose("p2", player: "p1"),
            .play(.bang2, player: "p1", target: "p2"),
            .shoot("p2"),
            .damage(1, player: "p2")
        ])
    }
}
