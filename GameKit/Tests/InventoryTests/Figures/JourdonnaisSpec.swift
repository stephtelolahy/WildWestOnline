//
//  JourdonnaisSpec.swift
//
//
//  Created by Hugues Telolahy on 03/11/2023.
//

import Game
import Nimble
import Quick

final class JourdonnaisSpec: QuickSpec {
    override func spec() {
        describe("Jourdonnais being shot") {
            context("flipped card is hearts") {
                it("should cancel shot") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.bang])
                                .withAttributes([.weapon: 1])
                        }
                        .withPlayer("p2") {
                            $0.withAbilities([.jourdonnais])
                                .withAttributes([.flippedCards: 1])
                        }
                        .withDeck(["c1-2♥️"])
                        .build()

                    // When
                    let action = GameAction.play(.bang, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state, choose: ["p2"])

                    // Then
                    expect(result) == [
                        .play(.bang, player: "p1"),
                        .chooseOne([
                            "p2": .nothing
                        ], player: "p1"),
                        .draw,
                        .cancel(.damage(1, player: "p2"))
                    ]
                }
            }
        }
    }
}
