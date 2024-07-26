//
//  SlabTheKillerTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import CardsData
import GameCore
import XCTest

final class SlabTheKillerTests: XCTestCase {
    func test_slabTheKiller_shouldRequireTwoMissesToCounterHisBang() throws {
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
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed1, .missed2])

        // Then
        XCTAssertEqual(
            result,
            [
                .play(.bang, player: "p1"),
                .discardPlayed(.bang, player: "p1"),
                .chooseOne(.target, options: ["p2"], player: "p1"),
                .choose("p2", player: "p1"),
                .chooseOne(.cardToPlayCounter, options: [.missed1, .missed2, .pass], player: "p2"),
                .choose(.missed1, player: "p2"),
                .play(.missed1, player: "p2"),
                .discardPlayed(.missed1, player: "p2"),
                .chooseOne(.cardToPlayCounter, options: [.missed2, .pass], player: "p2"),
                .choose(.missed2, player: "p2"),
                .play(.missed2, player: "p2"),
                .discardPlayed(.missed2, player: "p2")
            ]
        )
    }

    func test_slabTheKillerPlayingBang_withOneCounter_shouldDamage() throws {
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
        let result = try awaitAction(action, state: state, choose: ["p2", .missed])

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
                .discardPlayed(.missed, player: "p2"),
                .damage(1, player: "p2")
            ]
        )
    }
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
