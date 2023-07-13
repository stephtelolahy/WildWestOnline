//
//  GameOverSpec.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

import Quick
import Nimble
import Game

final class GameOverSpec: QuickSpec {
    override func spec() {
        describe("a game") {
            context("one player last") {
                it("should be over") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                        Player("p2")
                    }
                    .ability(.gameOverOnEliminated)

                    // When
                    let action = GameAction.eliminate(player: "p2")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p2"),
                        .setGameOver(winner: "p1")
                    ]
                }
            }

            context("two player") {
                it("should not be over") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1")
                        Player("p2")
                        Player("p3")
                    }

                    // When
                    let action = GameAction.eliminate(player: "p3")
                    let result = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p3")
                    ]
                }
            }
        }

        context("when over") {
            it("should not handle any action") {
                // Given
                let state = GameState()
                    .isOver("p1")

                // When
                let action = GameAction.play("c1", actor: "p1")
                let result = self.awaitAction(action, state: state)

                // Then
                expect(result).to(beEmpty())
            }
        }
    }
}
