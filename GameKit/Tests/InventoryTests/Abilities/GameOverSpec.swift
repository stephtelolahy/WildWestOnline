//
//  GameOverSpec.swift
//  
//
//  Created by Hugues Telolahy on 06/05/2023.
//

import Game
import Nimble
import Quick

final class GameOverSpec: QuickSpec {
    override func spec() {
        describe("a game") {
            context("one player last") {
                it("should be over") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1")
                        .withPlayer("p2") {
                            $0.withAttributes([.updateGameOverOnEliminated: 0])
                        }
                        .build()

                    // When
                    let action = GameAction.eliminate(player: "p2")
                    let (result, _) = self.awaitAction(action, state: state)

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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1")
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.eliminate(player: "p3")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .eliminate(player: "p3")
                    ]
                }
            }
        }

        context("when over") {
            it("should throw error") {
                // Given
                let state = GameState.makeBuilder()
                    .withWinner("p1")
                    .build()

                // When
                let action = GameAction.play("c1", player: "p1")
                let (_, error) = self.awaitAction(action, state: state)

                // Then
                expect(error) == .gameIsOver
            }
        }
    }
}
