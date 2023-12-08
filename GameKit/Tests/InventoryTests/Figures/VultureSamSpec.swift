//
//  VultureSamSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

import Game
import Nimble
import Quick

final class VultureSamSpec: QuickSpec {
    override func spec() {
        describe("VultureSam") {
            context("another player eliminated") {
                it("should draw its card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.vultureSam])
                        }
                        .withPlayer("p2") {
                            $0.withAbilities([.discardCardsOnEliminated])
                                .withHand(["c1"])
                                .withInPlay(["c2"])
                        }
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.eliminate(player: "p2")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p2"),
                        .drawInPlay("c2", target: "p2", player: "p1"),
                        .drawHand("c1", target: "p2", player: "p1")
                    ]
                }
            }
        }
    }
}
