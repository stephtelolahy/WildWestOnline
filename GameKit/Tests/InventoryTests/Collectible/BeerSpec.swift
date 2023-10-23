//
//  BeerSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Quick
import Nimble
import Game

final class BeerSpec: QuickSpec {
    override func spec() {
        describe("playing beer") {
            context("being damaged") {
                it("should heal one life point") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand([.beer])
                                .withHealth(2)
                                .withAttributes([.maxHealth: 3])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.play(.beer, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [.playImmediate(.beer, player: "p1"),
                                       .heal(1, player: "p1")]
                }
            }

            context("already max health") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand([.beer])
                                .withHealth(3)
                                .withAttributes([.maxHealth: 3])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.play(.beer, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .playerAlreadyMaxHealth("p1")
                }
            }

            context("two players left") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand([.beer])
                                .withHealth(2)
                                .withAttributes([.maxHealth: 3])
                        }
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.play(.beer, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noReq(.isPlayersAtLeast(3))
                }
            }
        }
    }
}
