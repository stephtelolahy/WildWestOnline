//
//  SidKetchumSpec.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

import Quick
import Nimble
import Game

final class SidKetchumSpec: QuickSpec {
    override func spec() {
        describe("playing SidKetchum") {
            context("having two cards") {
                it("should discard them and gain health") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withAbilities([.sidKetchum])
                                .withHand(["c1", "c2"])
                                .withHealth(1)
                                .withAttributes([.maxHealth: 4])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.sidKetchum, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["c1", "c2"], state: state)

                    // Then
                    expect(result) == [
                        .playAbility(.sidKetchum, player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c1": .discardHand("c1", player: "p1"),
                            "c2": .discardHand("c2", player: "p1"),
                        ]),
                        .discardHand("c1", player: "p1"),
                        .chooseOne(player: "p1", options: [
                            "c2": .discardHand("c2", player: "p1"),
                        ]),
                        .discardHand("c2", player: "p1"),
                        .heal(1, player: "p1")
                    ]
                }
            }

            context("having three cards") {
                it("should discard two cards and gain health") {

                }
            }

            context("having one card") {
                it("should throw error") {

                }
            }
        }
    }
}

