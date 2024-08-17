//
//  GeneralStoreTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import XCTest

final class GeneralStoreTests: XCTestCase {
    func test_playingGeneralStore_threePlayers_shouldAllowEachPlayerToChooseACard() throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.generalStore])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.preparePlay(.generalStore, player: "p1")
        let result = try awaitAction(action, state: state, choose: ["c1", "c2"])

        // Then
        XCTAssertEqual(result, [
            .preparePlay(.generalStore, player: "p1"),
            .discardPlayed(.generalStore, player: "p1"),
            .discover,
            .discover,
            .discover,
            .chooseOne(.cardToDraw, options: ["c1", "c2", "c3"], player: "p1"),
            .prepareChoose("c1", player: "p1"),
            .drawArena("c1", player: "p1"),
            .chooseOne(.cardToDraw, options: ["c2", "c3"], player: "p2"),
            .prepareChoose("c2", player: "p2"),
            .drawArena("c2", player: "p2"),
            .drawArena("c3", player: "p3")
        ])
    }
}
