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
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                String.saloon
                                String.gatling
                            }
                        }
                        .attribute(.maxHealth, 4)
                        .health(2)
                        Player("p2")
                            .attribute(.maxHealth, 4)
                    }
                        .turn("p1")

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
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                String.beer
                                String.missed
                            }
                        }
                        .attribute(.maxHealth, 4)
                        .health(4)
                        Player("p2")
                        Player("p3")
                    }
                        .turn("p1")

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
