//
//  StagecoachSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import Nimble
import Quick

final class StagecoachSpec: QuickSpec {
    override func spec() {
        describe("playing stagecoach") {
            it("should draw 2 cards") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.stagecoach])
                    }
                    .withDeck(["c1", "c2"])
                    .build()

                // When
                let action = GameAction.play(.stagecoach, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .play(.stagecoach, player: "p1"),
                    .drawDeck(player: "p1"),
                    .drawDeck(player: "p1")
                ]
            }
        }
    }
}
