//
//  EliminateOnLooseLastHealthSpec.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

import Game
import Quick
import Nimble

final class EliminateOnLooseLastHealthSpec: QuickSpec {
    override func spec() {

        describe("a player") {
            context("loosing last health") {
                it("should be eliminated") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                            .attribute(.health, 1)
                        Player("p2")
                    }
                    .ability(.eliminateOnLooseLastHealth)

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(1, player: "p1"),
                        .eliminate(player: "p1")
                    ]
                }
            }

            context("loosing non last health") {
                it("should remain active") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                            .attribute(.health, 2)
                    }
                    .ability(.eliminateOnLooseLastHealth)

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(1, player: "p1")
                    ]
                }
            }
        }
    }
}
