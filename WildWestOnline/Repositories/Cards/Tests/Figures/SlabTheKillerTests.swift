//
//  SlabTheKillerTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import CardsRepository
import GameCore
import XCTest

final class SlabTheKillerTests: XCTestCase {
    func test_slabTheKiller_shouldRequireTwoMissesToCounterHisBang() {
        // Given
        let state = Setup.buildGame(figures: [.slabTheKiller], deck: [], cards: Cards.all)

        // When
        let player = state.player(.slabTheKiller)

        // Then
        XCTAssertEqual(player.attributes[.missesRequiredForBang], 2)
    }

    func test_slabTheKillerPlayingBang_shouldRequiresTwoMisses() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
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
        let action = GameAction.play(.bang, player: "p1")
        let (result, _) = awaitAction(action, state: state, choose: ["p2", .missed])

        // Then
        XCTAssertEqual(
            result,
            [
                .play(.bang, player: "p1"),
                .discardPlayed(.bang, player: "p1"),
                .chooseOne(.target, options: ["p2"], player: "p1"),
                .choose("p2", player: "p1"),
                .chooseOne(.cardToPlayCounter, options: [.missed, .pass], player: "p2"),
                .choose(.missed, player: "p2"),
                .play(.missed, player: "p2"),
                .discardPlayed(.missed, player: "p2")
            ]
        )
    }
}
