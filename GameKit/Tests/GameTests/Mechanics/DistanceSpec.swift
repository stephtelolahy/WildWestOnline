//
//  DistanceSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

@testable import Game
import Nimble
import Quick

final class DistanceSpec: QuickSpec {
    override func spec() {
        describe("distance") {
            context("no equipement") {
                it("should be the lowest distance") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1")
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withPlayer("p4")
                        .withPlayer("p5")
                        .build()

                    // When
                    // Then
                    expect(state.playersAt(1, from: "p1")) == ["p2", "p5"]
                    expect(state.playersAt(2, from: "p1")) == ["p2", "p3", "p4", "p5"]

                    expect(state.playersAt(1, from: "p2")) == ["p1", "p3"]
                    expect(state.playersAt(2, from: "p2")) == ["p1", "p3", "p4", "p5"]

                    expect(state.playersAt(1, from: "p3")) == ["p2", "p4"]
                    expect(state.playersAt(2, from: "p3")) == ["p1", "p2", "p4", "p5"]

                    expect(state.playersAt(1, from: "p4")) == ["p3", "p5"]
                    expect(state.playersAt(2, from: "p4")) == ["p1", "p2", "p3", "p5"]

                    expect(state.playersAt(1, from: "p5")) == ["p1", "p4"]
                    expect(state.playersAt(2, from: "p5")) == ["p1", "p2", "p3", "p4"]
                }
            }

            context("having scope") {
                it("should decrement distance to others") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withAttributes([.scope: 1])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withPlayer("p4")
                        .withPlayer("p5")
                        .build()

                    // When
                    // Then
                    expect(state.playersAt(1, from: "p1")) == ["p2", "p3", "p4", "p5"]

                    expect(state.playersAt(1, from: "p2")) == ["p1", "p3"]
                    expect(state.playersAt(2, from: "p2")) == ["p1", "p3", "p4", "p5"]

                    expect(state.playersAt(1, from: "p3")) == ["p2", "p4"]
                    expect(state.playersAt(2, from: "p3")) == ["p1", "p2", "p4", "p5"]

                    expect(state.playersAt(1, from: "p4")) == ["p3", "p5"]
                    expect(state.playersAt(2, from: "p4")) == ["p1", "p2", "p3", "p5"]

                    expect(state.playersAt(1, from: "p5")) == ["p1", "p4"]
                    expect(state.playersAt(2, from: "p5")) == ["p1", "p2", "p3", "p4"]
                }
            }

            context("having mustang") {
                it("should increment distance from others") {
                    // Given
                    let state = GameState.makeBuilder()
                        .withPlayer("p1") {
                            $0.withAttributes([.mustang: 1])
                        }
                        .withPlayer("p2")
                        .withPlayer("p3")
                        .withPlayer("p4")
                        .withPlayer("p5")
                        .build()

                    // When
                    // Then
                    expect(state.playersAt(1, from: "p2")) == ["p3"]
                    expect(state.playersAt(2, from: "p2")) == ["p1", "p3", "p4", "p5"]

                    expect(state.playersAt(1, from: "p3")) == ["p2", "p4"]
                    expect(state.playersAt(2, from: "p3")) == ["p2", "p4", "p5"]
                    expect(state.playersAt(3, from: "p3")) == ["p1", "p2", "p4", "p5"]

                    expect(state.playersAt(1, from: "p4")) == ["p3", "p5"]
                    expect(state.playersAt(2, from: "p4")) == ["p2", "p3", "p5"]
                    expect(state.playersAt(3, from: "p4")) == ["p1", "p2", "p3", "p5"]

                    expect(state.playersAt(1, from: "p5")) == ["p4"]
                    expect(state.playersAt(2, from: "p5")) == ["p1", "p2", "p3", "p4"]
                }
            }
        }
    }
}
