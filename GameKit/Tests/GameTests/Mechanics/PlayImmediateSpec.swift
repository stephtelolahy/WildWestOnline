//
//  PlayImmediateSpec.swift
//
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Game
import Quick
import Nimble

final class PlayImmediateSpec: QuickSpec {
    override func spec() {
        let card1 = Card("c1") {
            CardEffect.nothing
                .triggered(.onPlay(.immediate))
        }

        describe("playing immediate card") {
            it("should discard immediately") {
                // Given
                let state = GameState {
                    Player("p1") {
                        Hand {
                            "c1"
                        }
                    }
                }
                .cardRef(["c1": card1])

                // When
                let action = GameAction.playImmediate("c1", actor: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.player("p1").hand.cards).to(beEmpty())
                expect(result.discard.top) == "c1"
            }

            it("should emit event") {
                // Given
                let state = GameState {
                    Player("p1") {
                        Hand {
                            "c1"
                        }
                    }
                }
                .cardRef(["c1": card1])

                // When
                let action = GameAction.playImmediate("c1", actor: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.event) == .playImmediate("c1", actor: "p1")
            }

            it("should increment counter") {
                // Given
                let state = GameState {
                    Player("p1") {
                        Hand {
                            "c1"
                        }
                    }
                }
                .cardRef(["c1": card1])

                // When
                let action = GameAction.playImmediate("c1", actor: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.playCounter["c1"]) == 1
            }

            it("should queue side effects") {
                // Given
                let state = GameState {
                    Player("p1") {
                        Hand {
                            "c1"
                        }
                    }
                }
                .cardRef(["c1": card1])

                // When
                let action = GameAction.playImmediate("c1", actor: "p1")
                let result = GameState.reducer(state, action)
                
                // Then
                expect(result.queue) == [
                    .resolve(.nothing, ctx: [.actor: "p1", .card: "c1"])
                ]
            }
        }
    }
}
