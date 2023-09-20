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
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing schofield") {
            context("no weapon inPlay") {
                it("should equip") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .schofield
                            }
                        }
                        .attribute(.weapon, 1)
                        .setupAttribute(.weapon, 1)
                    }

                    // When
                    let action = GameAction.play(.schofield, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 2, player: "p1")
                    ]
                }
            }

            context("already playing another weapon") {
                it("should discard previous weapon") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .schofield
                            }
                            InPlay {
                                .remington
                            }
                        }
                        .attribute(.weapon, 3)
                        .setupAttribute(.weapon, 1)
                        .ability(.discardPreviousWeaponOnPlayWeapon)
                    }

                    // When
                    let action = GameAction.play(.schofield, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playEquipment(.schofield, player: "p1"),
                        .setAttribute(.weapon, value: 2, player: "p1"),
                        .discardInPlay(.remington, player: "p1")
                    ]
                }
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
                        .attribute(.weapon, 2)
                        .setupAttribute(.weapon, 1)
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
