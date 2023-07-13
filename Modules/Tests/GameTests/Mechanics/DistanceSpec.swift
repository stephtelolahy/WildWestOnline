//
//  DistanceSpec.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

@testable import Game
import Quick
import Nimble

final class DistanceSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("distance") {
            context("no equipement") {
                it("should be the lowest distance") {
                    // Given
                    let state = GameState {
                        Player("p1")
                        Player("p2")
                        Player("p3")
                        Player("p4")
                        Player("p5")
                    }

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
                    let state = GameState {
                        Player("p1").attribute(.scope, 1)
                        Player("p2")
                        Player("p3")
                        Player("p4")
                        Player("p5")
                    }

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
                    let state = GameState {
                        Player("p1").attribute(.mustang, 1)
                        Player("p2")
                        Player("p3")
                        Player("p4")
                        Player("p5")
                    }

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
