//
//  BartCassidySpec.swift
//  
//
//  Created by Hugues Telolahy on 03/11/2023.
//
import Quick
import Nimble
import Game

final class BartCassidySpec: QuickSpec {
    override func spec() {
        describe("BartCassidy") {
            context("being damaged with 1 life point") {
                it("should draw a card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.bartCassidy])
                                .withHealth(3)
                        }
                        .withDeck(["c1"])
                        .build()

                    // When
                    let action = GameAction.damage(1, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(1, player: "p1"),
                        .draw(player: "p1")
                    ]
                }
            }

            context("being damaged with several life points") {
                it("should draw as many cards as damage") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.bartCassidy])
                                .withHealth(3)
                        }
                        .withDeck(["c1", "c2"])
                        .build()

                    // When
                    let action = GameAction.damage(2, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .damage(2, player: "p1"),
                        .draw(player: "p1"),
                        .draw(player: "p1")
                    ]
                }
            }


            context("being lethal damaged") {
                it("should do nothing") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.bartCassidy])
                                .withHealth(1)
                        }
                        .withDeck(["c1"])
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