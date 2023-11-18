//
//  JailSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 29/06/2023.
//

import Game
import Nimble
import Quick

final class JailSpec: QuickSpec {
    override func spec() {
        describe("playing jail") {
            context("against any player") {
                it("should handicap") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.jail])
                        }
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.play(.jail, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["p2"], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playHandicap(.jail, target: "p2", player: "p1")
                        ]),
                        .playHandicap(.jail, target: "p2", player: "p1")
                    ]
                }
            }

            xcontext("against sheriff") {
                it("should throw error") {
                }
            }
        }

        describe("triggering jail") {
            context("flipped card is hearts") {
                it("should escape from jail") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withInPlay([.jail])
                                .withAttributes([.drawOnSetTurn: 0, .flippedCards: 1, .startTurnCards: 2])
                        }
                        .withPlayer("p2")
                        .withDeck(["c1-2♥️", "c2", "c3"])
                        .build()

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.setTurn("p1"),
                                       .luck,
                                       .discardInPlay(.jail, player: "p1"),
                                       .draw(player: "p1"),
                                       .draw(player: "p1")]
                }
            }

            context("flipped card is spades") {
                it("should staty in jail by skipping turn") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withInPlay([.jail])
                                .withAttributes([.drawOnSetTurn: 0, .flippedCards: 1, .startTurnCards: 2])
                        }
                        .withPlayer("p2")
                        .withDeck(["c1-A♠️", "c2", "c3"])
                        .build()

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.setTurn("p1"),
                                       .luck,
                                       .cancel(.effect(.repeat(.attr(.startTurnCards), effect: .draw), ctx: EffectContext(actor: "p1", card: .drawOnSetTurn, event: .setTurn("p1")))),
                                       .discardInPlay(.jail, player: "p1"),
                                       .setTurn("p2")]
                }
            }
        }
    }
}
