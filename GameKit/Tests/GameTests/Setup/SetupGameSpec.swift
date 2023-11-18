//
//  SetupGameSpec.swift
//
//
//  Created by Hugues Telolahy on 19/05/2023.
//

import Game
import Nimble
import Quick

final class SetupGameSpec: QuickSpec {
    override func spec() {
        var game: GameState!

        describe("setup a game") {
            context("two players") {
                beforeEach {
                    // Given
                    let deck = Array(1...80).map { "c\($0)" }
                    let figures = ["p1", "p2"]
                    let cardRef: [String: Card] = [
                        "p1": Card("p1", attributes: [.maxHealth: 4, .startTurnCards: 2]),
                        "p2": Card("p2", attributes: [.maxHealth: 3, .startTurnCards: 3])
                    ]

                    // When
                    game = Setup.buildGame(figures: figures,
                                           deck: deck,
                                           cardRef: cardRef)
                }

                it("should create a game with given player number") {
                    expect(game.players.count) == 2
                    expect(game.playOrder).to(contain(["p1", "p2"]))
                    expect(game.startOrder).to(contain(["p1", "p2"]))
                }

                it("should set players to max health") {
                    expect(game.player("p1").health) == 4
                    expect(game.player("p2").health) == 3
                }

                it("should set players hand cards to health") {
                    expect(game.player("p1").hand.count) == 4
                    expect(game.player("p2").hand.count) == 3
                    expect(game.deck.count) == 73
                    expect(game.discard.top) == nil
                }

                it("should set undefined turn") {
                    expect(game.turn) == nil
                }

                it("should set figure attributes") {
                    expect(game.player("p1").attributes["p1"]) == 0
                    expect(game.player("p1").attributes[.startTurnCards]) == 2
                    expect(game.player("p1").attributes[.maxHealth]) == 4
                    expect(game.player("p2").attributes["p2"]) == 0
                    expect(game.player("p2").attributes[.startTurnCards]) == 3
                    expect(game.player("p2").attributes[.maxHealth]) == 3
                }
            }
        }
    }
}
