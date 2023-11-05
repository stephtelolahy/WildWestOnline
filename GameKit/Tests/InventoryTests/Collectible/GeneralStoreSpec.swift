//
//  GeneralStoreSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

import Quick
import Nimble
import Game

final class GeneralStoreSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("playing generalStore") {
            context("three players") {
                it("should allow each player to choose a card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.generalStore])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withDeck(["c1", "c2", "c3"])
                        .build()
                    
                    // When
                    let action = GameAction.play(.generalStore, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["c1", "c2"], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.generalStore, player: "p1"),
                        .discover,
                        .discover,
                        .discover,
                        .chooseOne(player: "p1", options: [
                            "c1": .chooseArena("c1", player: "p1"),
                            "c2": .chooseArena("c2", player: "p1"),
                            "c3": .chooseArena("c3", player: "p1")
                        ]),
                        .chooseArena("c1", player: "p1"),
                        .chooseOne(player: "p2", options: [
                            "c2": .chooseArena("c2", player: "p2"),
                            "c3": .chooseArena("c3", player: "p2")
                        ]),
                        .chooseArena("c2", player: "p2"),
                        .chooseArena("c3", player: "p3")
                    ]
                }
            }
            
            context("two players") {
                it("should allow each player to choose a card") {
                    // Given
                    let state = GameState.makeBuilderWithCardRef()
                        .withPlayer("p1") {
                            $0.withHand([.generalStore])
                        }
                        .withPlayer("p2")
                        .withDeck(["c1", "c2"])
                        .build()
                    
                    // When
                    let action = GameAction.play(.generalStore, player: "p1")
                    let (result, _) = self.awaitAction(action, choose: ["c1"], state: state)
                    
                    // Then
                    expect(result) == [
                        .playImmediate(.generalStore, player: "p1"),
                        .discover,
                        .discover,
                        .chooseOne(player: "p1", options: [
                            "c1": .chooseArena("c1", player: "p1"),
                            "c2": .chooseArena("c2", player: "p1")
                        ]),
                        .chooseArena("c1", player: "p1"),
                        .chooseArena("c2", player: "p2")
                    ]
                }
            }
        }
    }
}
