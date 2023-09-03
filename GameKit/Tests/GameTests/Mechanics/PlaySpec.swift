//
//  PlaySpec.swift
//
//
//  Created by Hugues Telolahy on 11/06/2023.
//

import Quick
import Nimble
import Game

final class PlaySpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing") {
            context("not playable card") {
                it("should throw error") {
                    // Given
                    let state = GameState {
                        Player("p1") {
                            Hand {
                                "c1"
                            }
                        }
                    }

                    // When
                    let action = GameAction.play("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .cardNotPlayable("c1")
                }
            }

            context("immediate card") {
                it("should discard immediately") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .when(.onPlayImmediate)
                    }
                    let state = GameState {
                        Player("p1") {
                            Hand {
                                "c1"
                            }
                        }
                    }
                    .cardRef(["c1": card1])

                    // When
                    let action = GameAction.play("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.queue) == [
                        .playImmediate("c1", player: "p1")
                    ]
                    expect(result.event) == action
                }
            }

            context("equipment card") {
                it("should put in self's play") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .when(.onPlayEquipment)
                    }
                    let state = GameState {
                        Player("p1") {
                            Hand {
                                "c1"
                            }
                        }
                    }
                    .cardRef(["c1": card1])

                    // When
                    let action = GameAction.play("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.queue) == [
                        .playEquipment("c1", player: "p1")
                    ]
                    expect(result.event) == action
                }
            }

            context("handicap card") {
                it("should put in target's play") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .target(.selectAny)
                            .when(.onPlayHandicap)
                    }
                    let state = GameState {
                        Player("p1") {
                            Hand {
                                "c1"
                            }
                        }
                        Player("p2")
                        Player("p3")
                    }
                    .cardRef(["c1": card1])

                    // When
                    let action = GameAction.play("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.queue) == [
                        .chooseOne(player: "p1", options: [
                            "p3": .playHandicap("c1", target: "p3", player: "p1"),
                            "p2": .playHandicap("c1", target: "p2", player: "p1")])
                    ]
                    expect(result.event) == action
                }
            }
        }
    }
}
