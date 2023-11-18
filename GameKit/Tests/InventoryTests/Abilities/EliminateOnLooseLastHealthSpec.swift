//
//  EliminateOnLooseLastHealthSpec.swift
//  
//
//  Created by Hugues Telolahy on 05/05/2023.
//

import Game
import Nimble
import Quick

final class EliminateOnLooseLastHealthSpec: QuickSpec {
    override func spec() {
        describe("a player") {
            context("loosing last health") {
                it("should be eliminated") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHealth(1)
                                .withAttributes([.eliminateOnDamageLethal: 0])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

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
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHealth(2)
                                .withAttributes([.eliminateOnDamageLethal: 0])
                        }
                        .build()

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(1, player: "p1")
                    ]
                }
            }
        }
    }
}
