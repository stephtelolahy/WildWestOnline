//
//  ActiveCardsSpec.swift
//  
//
//  Created by Hugues Telolahy on 05/06/2023.
//

import Quick
import Nimble
import Game
import Inventory

final class ActiveCardsSpec: QuickSpec {
    override func spec() {
        describe("activating card") {
            context("game idle") {
                it("should emit current turn's active card") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                String.beer
                                String.saloon
                                String.gatling
                            }
                        }
                        .attribute(.health, 2)
                        .attribute(.maxHealth, 4)
                        Player("p2")
                    }
                    .turn("p1")

                    // When
                    let action = GameAction.group([])
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .activateCard(player: "p1", cards: [.saloon, .gatling])
                    ]
                }
            }
        }
    }
}
