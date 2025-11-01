//
//  SlabTheKillerTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import GameData
import GameFeature
import Testing

struct SlabTheKillerTests {
    @Test(.disabled()) func slabTheKiller_shouldRequireTwoMissesToCounterHisBang() async throws {
        // Given
        let state = Setup.buildGame(figures: [.slabTheKiller], deck: [], cards: Cards.all)

        // When
        let player = state.player(.slabTheKiller)

        // Then
        #expect(player.attributes[.missesRequiredForBang] == 2)
    }

    @Test(.disabled()) func slabTheKillerPlayingBang_shouldRequiresTwoMisses() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 2, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed1, .missed2])

        // Then
        XCTAssertEqual(
            result,
            [
                .play(.bang, actor: "p1"),
                .chooseOne(.target, options: ["p2"], player: "p1"),
                .chooseOne(.cardToPlayCounter, options: [.missed1, .missed2, .pass], player: "p2"),
                .play(.missed1, actor: "p2"),
                .chooseOne(.cardToPlayCounter, options: [.missed2, .pass], player: "p2"),
                .play(.missed2, actor: "p2")
            ]
        )
    }

    @Test(.disabled()) func slabTheKillerPlayingBang_withOneCounter_shouldDamage() async throws {
        // Given
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 2, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameFeature.Action.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        XCTAssertEqual(
            result,
            [
                .play(.bang, actor: "p1"),
                .chooseOne(.target, options: ["p2"], player: "p1"),
                .chooseOne(.cardToPlayCounter, options: [.missed, .pass], player: "p2"),
                .play(.missed, actor: "p2"),
                .damage(1, player: "p2")
            ]
        )
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
