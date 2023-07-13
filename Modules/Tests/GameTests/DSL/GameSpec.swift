//
//  GameSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Quick
import Nimble
import Game
import Foundation

final class GameSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("a game") {
            var sut: GameState!
            context("by default") {
                beforeEach {
                    sut = GameState()
                }
                
                it("should have empty deck") {
                    expect(sut.deck.count) == 0
                }
                
                it("should have empty discard") {
                    expect(sut.discard.count) == 0
                }
                
                it("should not have arena") {
                    expect(sut.arena) == nil
                }
                
                it("should not be over") {
                    expect(sut.isOver) == nil
                }
                
                it("should not have turn") {
                    expect(sut.turn) == nil
                }
                
                it("should have empty players") {
                    expect(sut.players).to(beEmpty())
                }
            }
            
            context("initialized with deck") {
                it("should have deck cards") {
                    // Given
                    // When
                    let sut = GameState {
                        Deck {
                            "c1"
                            "c2"
                        }
                    }
                    
                    // Then
                    expect(sut.deck.count) == 2
                }
            }
            
            context("initialized with discard pile") {
                it("should have discarded cards") {
                    // Given
                    // When
                    let sut = GameState {
                        DiscardPile {
                            "c1"
                            "c2"
                        }
                    }
                    
                    // Then
                    expect(sut.discard.count) == 2
                }
            }
            
            context("initialized with arena") {
                it("should have arena cards") {
                    // Given
                    // When
                    let sut = GameState {
                        Arena {
                            "c1"
                            "c2"
                        }
                    }
                    
                    // Then
                    expect(sut.arena?.cards) == ["c1", "c2"]
                }
            }
            
            context("modified game over") {
                it("should be over") {
                    // Given
                    // When
                    let sut = GameState().isOver("p1")
                    
                    // Then
                    expect(sut.isOver) == GameOver(winner: "p1")
                }
            }
            
            context("modified turn") {
                it("should have turn") {
                    // Given
                    // When
                    let sut = GameState().turn("p1")
                    
                    // Then
                    expect(sut.turn) == "p1"
                }
            }

            context("modified queue") {
                it("should have queued actions") {
                    // Given
                    // When
                    let sut = GameState()
                        .queue([.draw(player: "p1")])

                    // Then
                    expect(sut.queue) == [
                        .draw(player: "p1")
                    ]
                }
            }
            
            context("initialized with players") {
                it("should have players") {
                    // Given
                    // When
                    let sut = GameState {
                        Player("p1")
                        Player("p2")
                    }
                    
                    // Then
                    expect(sut.setupOrder) == ["p1", "p2"]
                    expect(sut.playOrder) == ["p1", "p2"]
                    expect(sut.players["p1"]) != nil
                    expect(sut.players["p2"]) != nil
                }
            }

            it("should be serializable") {
                // Given
                let JSON = """
                {
                  "isOver": {
                     "winner": "p1"
                  },
                  "players": {
                    "p1": {
                      "id": "p1",
                      "name": "p1",
                      "maxHealth": 4,
                      "health": 3,
                      "handLimit": 3,
                      "weapon": 1,
                      "mustang": 0,
                      "scope": 1,
                      "abilities": [],
                      "starTurnCards": 2,
                      "attributes": {},
                      "hand": {
                        "visibility": "p1",
                        "cards": []
                      },
                      "inPlay": {
                        "cards": []
                      }
                    }
                  },
                  "attributes": {},
                  "abilities": [],
                  "playOrder": [
                    "p1"
                  ],
                  "setupOrder": [
                    "p1"
                  ],
                  "turn": "p1",
                  "deck": {
                    "cards": [
                      "c1"
                    ]
                  },
                  "discard": {
                    "cards": [
                      "c2"
                    ]
                  },
                  "queue": [],
                  "playCounter": {},
                  "cardRef": {},
                }
                """
                // swiftlint:disable:next: force_unwrapping
                let jsonData = JSON.data(using: .utf8)!

                // When
                let sut = try JSONDecoder().decode(GameState.self, from: jsonData)

                // Then
                expect(sut.isOver) == GameOver(winner: "p1")
                expect(sut.players["p1"]) != nil
                expect(sut.playOrder) == ["p1"]
                expect(sut.turn) == "p1"
                expect(sut.deck.count) == 1
                expect(sut.discard.count) == 1
                expect(sut.arena) == nil
            }
        }
    }
}
