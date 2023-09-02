//
//  SchofieldSpec.swift
//
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Quick
import Nimble
import Game

final class SchofieldSpec: QuickSpec {
    override func spec() {
        describe("playing schofield") {
            it("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .schofield
                        }
                    }
                }

                // When
                let action = GameAction.play(.schofield, actor: "p1")
                let result = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.schofield, actor: "p1"),
                    .setAttribute(.weapon, value: 2, player: "p1")
                ]
            }
        }

        describe("discarding schofield") {
            context("from inPlay") {
                it("should reset to default weapon") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            InPlay {
                                .schofield
                            }
                        }
                    }

                    // When
                    let action = GameAction.discardInPlay(.schofield, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .discardInPlay(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 1, player: "p1")
                    ]
                }
            }

            context("from hand") {
                it("should do nothing") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .schofield
                            }
                        }
                    }

                    // When
                    let action = GameAction.discardHand(.schofield, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .discardHand(.schofield, player: "p1")
                    ]
                }
            }
        }
    }
}
