//
//  DynamiteSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/06/2023.
//

import Game
import Nimble
import Quick

final class DynamiteSpec: QuickSpec {
    override func spec() {
        describe("playing dynamite") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.dynamite])
                    }
                    .build()

                // When
                let action = GameAction.play(.dynamite, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.dynamite, player: "p1")
                ]
            }
        }

        describe("triggering dynamite") {
            context("flipped card is hearts") {
                it("should pass inPlay") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withInPlay([.dynamite])
                                .withAttributes([.drawOnSetTurn: 0, .flippedCards: 1, .startTurnCards: 2])
                        }
                        .withPlayer("p2")
                        .withDeck(["c1-9♦️", "c2", "c3"])
                        .build()

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.setTurn("p1"),
                                       .draw,
                                       .passInPlay(.dynamite, target: "p2", player: "p1"),
                                       .drawDeck(player: "p1"),
                                       .drawDeck(player: "p1")]
                }
            }

            context("flipped card is spades") {
                context("not lethal") {
                    it("should apply damage and discard card") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withInPlay([.dynamite])
                                    .withAttributes([.drawOnSetTurn: 0, .flippedCards: 1, .startTurnCards: 2])
                                    .withHealth(4)
                            }
                            .withDeck(["c1-8♠️", "c2", "c3"])
                            .build()

                        // When
                        let action = GameAction.setTurn("p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [.setTurn("p1"),
                                           .draw,
                                           .damage(3, player: "p1"),
                                           .discardInPlay("dynamite", player: "p1"),
                                           .drawDeck(player: "p1"),
                                           .drawDeck(player: "p1")]
                    }
                }

                context("lethal") {
                    it("should eliminate") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withInPlay([.jail, .dynamite])
                                    .withAttributes([
                                            .eliminateOnDamageLethal: 0,
                                            .discardCardsOnEliminated: 0,
                                            .nextTurnOnEliminated: 0,
                                            .flippedCards: 1,
                                            .startTurnCards: 2
                                    ])
                                    .withHealth(3)
                            }
                            .withPlayer("p2") {
                                $0.withAttributes([.drawOnSetTurn: 0, .startTurnCards: 2])
                            }
                            .withPlayer("p3")
                            .withDeck(["c1-8♠️", "c2", "c3"])
                            .build()

                        // When
                        let action = GameAction.setTurn("p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [.setTurn("p1"),
                                           .draw,
                                           .damage(3, player: "p1"),
                                           .eliminate(player: "p1"),
                                           .discardInPlay(.jail, player: "p1"),
                                           .discardInPlay(.dynamite, player: "p1"),
                                           .setTurn("p2"),
                                           .drawDeck(player: "p2"),
                                           .drawDeck(player: "p2")]
                    }
                }
            }
        }
    }
}
