//
//  MissedTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Testing
import Bang

struct MissedTest {
    @Test func beingShot_holdingMissedCard_shouldAskToCounter() async throws {
        // Given
        let state = GameState.makeBuilderWithAllCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2") {
                $0.withHand([.missed])
            }
            .build()

        // When
        let action = GameAction.play(.bang, player: "p1")
        let choices: [Choice] = [
            .init(options: ["p2"], selectionIndex: 0),
            .init(options: [.missed, "pass"], selectionIndex: 0)
        ]
        let result = try await dispatchUntilCompleted(action, state: state, expectedChoices: choices)

        // Then
        #expect(result == [
                .play(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .shoot("p2", player: "p1"),
                .choose(.missed, player: "p2"),
                .play(.missed, player: "p2"),
                .counterShot(player: "p2")
        ])
    }
/*
    @Test func beingShot_withoutMissedCard_shouldNotAskToCounter() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2"])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .damage(1, player: "p2")
        ])
    }

    @Test func beingShot_holdingMissedCards_shouldAskToCounter() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.bang])
                    .withAttributes([.bangsPerTurn: 1, .missesRequiredForBang: 1, .weapon: 1])
            }
            .withPlayer("p2") {
                $0.withHand([.missed1, .missed2])
                    .withAbilities([.playCounterCardsOnShot])
            }
            .build()

        // When
        let action = GameAction.preparePlay(.bang, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["p2", .missed2])

        // Then
        XCTAssertEqual(result, [
            .playBrown(.bang, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToPlayCounter, options: [.missed1, .missed2, .pass], player: "p2"),
            .playBrown(.missed2, player: "p2")
        ])
    }

    @Test func playMissed_withoutBeingShoot_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.missed])
            }
            .withTurn("p1")
            .build()

        // When
        // Then
        let action = GameAction.preparePlay(.missed, player: "p1")
        XCTAssertThrowsError(try awaitAction(action, state: state)) { error in
            XCTAssertEqual(error as? SequenceState.Error, .noShootToCounter)
        }
    }
 */
}

private extension String {
    static let missed1 = "\(String.missed)-1"
    static let missed2 = "\(String.missed)-2"
}
