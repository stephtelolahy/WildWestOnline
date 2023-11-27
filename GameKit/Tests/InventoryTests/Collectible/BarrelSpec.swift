//
//  BarrelTests.swift
//
//
//  Created by Hugues Telolahy on 18/06/2023.
//

import Game
import Nimble
import Quick

final class BarrelSpec: QuickSpec {
    override func spec() {
        describe("playing barrel") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.barrel])
                    }
                    .build()

                // When
                let action = GameAction.play(.barrel, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [.playEquipment(.barrel, player: "p1")]
            }
        }

        describe("triggering barrel") {
            context("one flipped card") {
                context("flipped card is hearts") {
                    it("should cancel shot") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.bang])
                                    .withAttributes([.weapon: 1])
                            }
                            .withPlayer("p2") {
                                $0.withInPlay([.barrel])
                                    .withAttributes([.flippedCards: 1])
                            }
                            .withDeck(["c1-2♥️"])
                            .build()

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .draw,
                            .cancel(.damage(1, player: "p2"))
                        ]
                    }
                }

                context("flipped card is spades") {
                    it("should apply damage") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.bang])
                                    .withAttributes([.weapon: 1])
                            }
                            .withPlayer("p2") {
                                $0.withInPlay([.barrel])
                                    .withAttributes([.flippedCards: 1])
                            }
                            .withDeck(["c1-A♠️"])
                            .build()

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .draw,
                            .damage(1, player: "p2")
                        ]
                    }
                }
            }

            context("two flipped cards") {
                context("one of flipped card is hearts") {
                    it("should cancel shot") {
                        // Given
                        let state = GameState.makeBuilderWithCardRef()
                            .withPlayer("p1") {
                                $0.withHand([.bang])
                                    .withAttributes([.weapon: 1])
                            }
                            .withPlayer("p2") {
                                $0.withInPlay([.barrel])
                                    .withAttributes([.flippedCards: 2])
                            }
                            .withDeck(["c1-A♠️", "c1-2♥️"])
                            .build()

                        // When
                        let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                        let (result, _) = self.awaitAction(action, state: state)

                        // Then
                        expect(result) == [
                            .playImmediate(.bang, target: "p2", player: "p1"),
                            .draw,
                            .draw,
                            .cancel(.damage(1, player: "p2"))
                        ]
                    }
                }
            }

            context("holding missed cards") {
                it("should not choose play missed") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.weapon: 1])
                        }
                        .withPlayer("p2") {
                            $0.withHand([.missed])
                                .withInPlay([.barrel])
                                .withAttributes([.flippedCards: 1, .activateCounterCardsOnShot: 0])
                        }
                        .withDeck(["c1-2♥️"])
                        .build()

                    // When
                    let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .draw,
                        .cancel(.damage(1, player: "p2"))
                    ]
                }
            }
        }
    }
}
