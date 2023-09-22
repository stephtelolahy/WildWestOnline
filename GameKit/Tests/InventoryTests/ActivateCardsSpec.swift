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
            context("game idle") {
                it("should emit current turn's active cards") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                String.beer
                                String.saloon
                                String.gatling
                            }
                        }
                        .attribute(.maxHealth, 4)
                        .ability(.evaluateActiveCardsOnIdle)
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
        }
    }
}
