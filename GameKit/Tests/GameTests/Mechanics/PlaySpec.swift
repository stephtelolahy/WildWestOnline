//
//  PlaySpec.swift
//
//
//  Created by Hugues Telolahy on 11/06/2023.
//

import Game
import Nimble
import Quick

final class PlaySpec: QuickSpec {
    override func spec() {
        describe("playing") {
            context("not playable card") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand(["c1"])
                        }
                        .build()

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
                            .on([.playImmediate])
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
                    expect(result.sequence) == [
                        .playImmediate("c1", player: "p1")
                    ]
                }
            }

            context("ability card") {
                it("should invoke ability") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .on([.playAbility])
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
                    expect(result.sequence) == [
                        .playAbility("c1", player: "p1")
                    ]
                }
            }

            context("equipment card") {
                it("should put in self's play") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .on([.playEquipment])
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
                    expect(result.sequence) == [
                        .playEquipment("c1", player: "p1")
                    ]
                }
            }

            context("handicap card") {
                it("should put in target's play") {
                    // Given
                    let card1 = Card("c1") {
                        CardEffect.nothing
                            .target(.selectAny)
                            .on([.playHandicap])
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
                    expect(result.sequence) == [
                        .chooseOne([
                            "p3": .playHandicap("c1", target: "p3", player: "p1"),
                            "p2": .playHandicap("c1", target: "p2", player: "p1")
                        ], player: "p1")
                    ]
                }
            }
        }
    }
}
