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
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1"])
                        }
                        .withCardRef(["c1": card1])
                        .build()

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

            context("ability card") {
                it("should invoke ability") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .when(.onPlayAbility)
                    }
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withAbilities(["c1"])
                        }
                        .withCardRef(["c1": card1])
                        .build()

                    // When
                    let action = GameAction.play("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.queue) == [
                        .playAbility("c1", player: "p1")
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
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1"])
                        }
                        .withCardRef(["c1": card1])
                        .build()

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
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1"])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withCardRef(["c1": card1])
                        .build()

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
