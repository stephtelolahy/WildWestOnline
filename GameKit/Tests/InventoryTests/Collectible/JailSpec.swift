//
//  JailSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 29/06/2023.
//

import Quick
import Nimble
import Game

final class JailSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing jail") {
            context("against any player") {
                it("should handicap") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .jail
                            }
                        }
                        .attribute(.flippedCards, 1)
                        Player("p2")
                    }

                    // When
                    let action = GameAction.play(.jail, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2"], state: state)

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
                it("should scape from jail") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            InPlay {
                                .jail
                            }
                        }
                        .attribute(.flippedCards, 1)
                        .attribute(.startTurnCards, 2)
                        .ability(.drawOnSetTurn)
                        Player("p2")
                        Deck {
                            "c1-2♥️"
                            "c2"
                            "c3"
                        }
                    }

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
                it("should skip turn") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            InPlay {
                                .jail
                            }
                        }
                        .attribute(.flippedCards, 1)
                        Player("p2")
                            .attribute(.startTurnCards, 2)
                            .ability(.drawOnSetTurn)
                        Deck {
                            "c1-A♠️"
                            "c2"
                            "c3"
                            "c4"
                            "c5"
                        }
                    }

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.setTurn("p1"),
                                       .luck,
                                       .discardInPlay(.jail, player: "p1"),
                                       .setTurn("p2"),
                                       .draw(player: "p2"),
                                       .draw(player: "p2")]
                }
            }
        }
    }
}
