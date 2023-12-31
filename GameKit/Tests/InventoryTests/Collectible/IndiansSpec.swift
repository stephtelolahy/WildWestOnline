//
//  IndiansSpec.swift
//  
//
//  Created by Hugues Telolahy on 22/04/2023.
//

import Game
import Nimble
import Quick

final class IndiansSpec: QuickSpec {
    override func spec() {
        describe("playing Indians") {
            context("three players") {
                it("should allow each player to counter or pass") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.indians])
                        }
                        .withPlayer("p2") {
                            $0.withHand([.bang])
                        }
                        .withPlayer("p3")
                        .build()

                    // When
                    let action = GameAction.play(.indians, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: [.bang])

                    // Then
                    expect(result) == [
                        .playImmediate(.indians, player: "p1"),
                        .chooseOne([
                            .bang: .discardHand(.bang, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ], player: "p2"),
                        .discardHand(.bang, player: "p2"),
                        .damage(1, player: "p3")
                    ]
                }
            }

            context("two players") {
                it("should allow each player to counter") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.indians])
                        }
                        .withPlayer("p2") {
                            $0.withHand([.bang])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.indians, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: [.bang])

                    // Then
                    expect(result) == [
                        .playImmediate(.indians, player: "p1"),
                        .chooseOne([
                            .bang: .discardHand(.bang, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ], player: "p2"),
                        .discardHand(.bang, player: "p2")
                    ]
                }
            }
        }
    }
}
