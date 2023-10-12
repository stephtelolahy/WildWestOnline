//
//  MissedSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 12/10/2023.
//

import Quick
import Nimble
import Game

final class MissedSpec: QuickSpec {
    override func spec() {
        describe("playing bang") {
            context("having missed") {
                it("should ask to counter or pass") {
                    // Given
                    let state = createGameWithCardRef {
                        Player("p1") {
                            Hand {
                                .bang
                            }
                        }
                        .attribute(.bangsPerTurn, 1)
                        .attribute(.weapon, 1)
                        Player("p2") {
                            Hand {
                                .missed
                            }
                        }
                    }

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, choices: ["p2", .missed], state: state)

                    // Then
                    expect(result) == [
                        .chooseOne(player: "p1", options: [
                            "p2": .playImmediate(.bang, target: "p2", player: "p1")
                        ]),
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .chooseOne(player: "p2", options: [
                            .missed: .discardHand(.missed, player: "p2"),
                            .pass: .damage(1, player: "p2")
                        ]),
                        .discardHand(.missed, player: "p2")
                    ]
                }
            }
        }
    }
}
