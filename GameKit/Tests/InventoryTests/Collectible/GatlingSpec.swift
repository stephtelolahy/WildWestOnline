//
//  GatlingSpec.swift
//
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import Quick
import Nimble
import Game

final class GatlingSpec: QuickSpec {
    override func spec() {
        describe("playing gatling") {
            context("three players") {
                it("should damage each player") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.gatling])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, player: "p1"),
                        .damage(1, player: "p2"),
                        .damage(1, player: "p3")
                    ]
                }
            }

            context("two players") {
                it("should damage each player") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.gatling])
                        }
                        .withPlayer("p2")
                        .build()

                    // When
                    let action = GameAction.play(.gatling, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.gatling, player: "p1"),
                        .damage(1, player: "p2")
                    ]
                }
            }
        }
    }
}
