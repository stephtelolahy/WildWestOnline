//
//  BlackJackSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 10/11/2023.
//

import Quick
import Nimble
import Game

final class BlackJackSpec: QuickSpec {
    override func spec() {
        describe("BlackJack starting turn") {
            context("drawn card is Red") {
                it("should draw an extra card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.blackJack])
                                .withAttributes([.startTurnCards: 2])
                        }
                        .withDeck(["c1", "c2-A♥️", "c3"])
                        .build()

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .setTurn("p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1"),
                        .reveal("c2-A♥️", player: "p1"),
                        .draw(player: "p1")
                    ]
                }
            }

            context("draw card is Black") {
                it("should do nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.blackJack])
                                .withAttributes([.startTurnCards: 2])
                        }
                        .withDeck(["c1", "c2-A♠️", "c3"])
                        .build()

                    // When
                    let action = GameAction.setTurn("p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .setTurn("p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1"),
                        .reveal("c2-A♠️", player: "p1")
                    ]
                }
            }
        }
    }
}
