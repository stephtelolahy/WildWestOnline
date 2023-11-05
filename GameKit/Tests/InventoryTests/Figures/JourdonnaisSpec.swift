//
//  JourdonnaisSpec.swift
//
//
//  Created by Hugues Telolahy on 03/11/2023.
//
import Quick
import Nimble
import Game

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
                    let action = GameAction.playImmediate(.bang, target: "p2", player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)

                    // Then
                    expect(result) == [
                        .playImmediate(.bang, target: "p2", player: "p1"),
                        .luck,
                        .cancel(.damage(1, player: "p2"))
                    ]
                }
            }
        }
    }
}
