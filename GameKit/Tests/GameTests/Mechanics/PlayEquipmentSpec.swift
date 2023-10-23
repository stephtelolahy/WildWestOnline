//
//  PlayEquipmentSpec.swift
//
//
//  Created by Hugues Telolahy on 10/06/2023.
//

import Quick
import Nimble
import Game

final class PlayEquipmentSpec: QuickSpec {
    override func spec() {
        let card1 = Card("c1") {
            CardEffect.nothing
                .when(.onPlayEquipment)
        }

        describe("playing equipment a card") {
            context("not in play") {
                it("should put card in play") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand("c1", "c2")
                        }
                        .withCardRef(["c1": card1])
                        .build()

                    // When
                    let action = GameAction.playEquipment("c1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.player("p1").hand.cards) == ["c2"]
                    expect(result.player("p1").inPlay.cards) == ["c1"]
                    expect(result.discard.count) == 0
                }
            }

            context("having same card in play") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand("c-1")
                                .withInPlay("c-2")
                        }
                        .withCardRef(["c": card1])
                        .build()

                    // When
                    let action = GameAction.playEquipment("c-1", player: "p1")
                    let result = GameState.reducer(state, action)

                    // Then
                    expect(result.error) == .cardAlreadyInPlay("c")
                }
            }
        }
    }
}
