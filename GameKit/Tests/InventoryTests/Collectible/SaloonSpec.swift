//
//  SaloonSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Quick
import Nimble
import Game

final class SaloonSpec: QuickSpec {
    override func spec() {
        describe("playing saloon") {
            context("any players damaged") {
                it("should heal one life point") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand([.saloon])
                                .withHealth(4)
                                .withAttributes([.maxHealth: 4])
                        }
                        .withPlayer("p2") {
                            $0.withHealth(2)
                                .withAttributes([.maxHealth: 4])
                        }
                        .withPlayer("p3") {
                            $0.withHealth(3)
                                .withAttributes([.maxHealth: 4])
                        }
                        .build()

                    // When
                    let action = GameAction.play(.saloon, player: "p1")
                    let (result, _) = self.awaitAction(action, state: state)
                    
                    // Then
                    expect(result) == [.playImmediate(.saloon, player: "p1"),
                                       .heal(1, player: "p2"),
                                       .heal(1, player: "p3")]
                }
            }
            
            context("no player damaged") {
                it("should throw error") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withHand([.saloon])
                                .withHealth(4)
                                .withAttributes([.maxHealth: 4])
                        }
                        .withPlayer("p2") {
                            $0.withHealth(3)
                                .withAttributes([.maxHealth: 3])
                        }
                        .build()
                    
                    // When
                    let action = GameAction.play(.saloon, player: "p1")
                    let (_, error) = self.awaitAction(action, state: state)

                    // Then
                    expect(error) == .noPlayer(.damaged)
                }
            }
        }
    }
}
