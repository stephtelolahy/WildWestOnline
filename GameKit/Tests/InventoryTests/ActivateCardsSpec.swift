//
//  ActivateCardsSpec.swift
//
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import Quick
import Nimble
import Game
import Inventory

final class ActivateCardsSpec: QuickSpec {
    override func spec() {
        describe("activating cards") {
            context("card playable") {
                it("should activate") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.saloon, .gatling])
                                .withAttributes([.maxHealth: 4])
                                .withHealth(2)
                        }
                        .withPlayer("p2") {
                            $0.withAttributes([.maxHealth: 4])
                        }
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.group([])
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .activateCards(player: "p1", cards: [.saloon, .gatling])
                    ]
                }
            }

            context("card not playable") {
                it("should not activate") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.beer, .missed])
                                .withAttributes([.maxHealth: 4])
                                .withHealth(4)
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withTurn("p1")
                        .build()

                    // When
                    let action = GameAction.group([])
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result).to(beEmpty())
                }
            }
        }
    }
}
