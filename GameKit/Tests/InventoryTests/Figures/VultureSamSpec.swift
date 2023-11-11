//
//  VultureSamSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

import Quick
import Nimble
import Game

final class VultureSamSpec: QuickSpec {
    override func spec() {
        describe("VultureSam") {
            context("another player eliminated") {
                it("should draw its card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAttributes([.vultureSam: 0])
                        }
                        .withPlayer("p2") {
                            $0.withAttributes([.discardCardsOnEliminated: 0])
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
                        .stealInPlay("c2", target: "p2", player: "p1"),
                        .stealHand("c1", target: "p2", player: "p1")
                    ]
                }
            }
        }
    }
}
