//
//  GeneralStoreTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import Game
import XCTest

final class GeneralStoreTests: XCTestCase {
    func test_playingGeneralStore_threePlayers_shouldAllowEachPlayerToChooseACard() {
        // Given
        let state = GameState.makeBuilderWithCardRef()
            .withPlayer("p1") {
                $0.withHand([.generalStore])
            }
            .withPlayer("p2")
            .withPlayer("p3")
            .withDeck(["c1", "c2", "c3"])
            .build()

        // When
        let action = GameAction.play(.generalStore, player: "p1")
        let (result, _) = self.awaitAction(action, state: state, choose: ["c1", "c2"])

        // Then
        XCTAssertEqual(result, [
            .play(.generalStore, player: "p1"),
            .discardPlayed(.generalStore, player: "p1"),
            .discover,
            .discover,
            .discover,
            .chooseOne(.card, options: ["c1", "c2", "c3"], player: "p1"),
            .choose("c1", player: "p1"),
            .drawArena("c1", player: "p1"),
            .chooseOne(.card, options: ["c2", "c3"], player: "p2"),
            .choose("c2", player: "p2"),
            .drawArena("c2", player: "p2"),
            .drawArena("c3", player: "p3")
        ])
    }
}
