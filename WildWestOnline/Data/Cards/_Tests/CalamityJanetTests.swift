//
//  CalamityJanetTest.swift
//
//
//  Created by Hugues Telolahy on 20/11/2023.
//

import GameCore
import Testing

struct CalamityJanetTests {
    @Test(.disabled()) func calamityJanetPlayingBang_shouldPlayAsBang() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAttributes([.bangsPerTurn: 1, .weapon: 1])
                    .withHand([.bang])
                    .withFigure(.calamityJanet)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .play(.bang, actor: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test(.disabled()) func calamityJanetPlayingMissed_shouldPlayAsBang() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withAttributes([.bangsPerTurn: 1, .weapon: 1])
                    .withHand([.missed])
                    .withFigure(.calamityJanet)
            }
            .withPlayer("p2")
            .withTurn("p1")
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.missed, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        #expect(result == [
            .play(.missed, actor: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test(.disabled()) func calamityJanetBeingShot_holdingBang_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.bang])
                    .withAbilities([.playCounterCardsOnShot])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .bang])

        // Then
        #expect(result == [
            .play(.bang, actor: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToPlayCounter, options: [.bang, .pass], player: "p2"),
            .play(.bang, actor: "p2")
        ])
    }

    @Test(.disabled()) func calamityJanetBeingShot_holdingMissed_shouldAskToCounter() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.playCounterCardsOnShot])
                    .withFigure(.calamityJanet)
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        #expect(result == [
            .play(.bang, actor: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToPlayCounter, options: [.missed, .pass], player: "p2"),
            .play(.missed, actor: "p2")
        ])
    }
}
