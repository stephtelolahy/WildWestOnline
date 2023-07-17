//
//  PlayerSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//
import Game
import Quick
import Nimble
import Foundation

final class PlayerSpec: QuickSpec {
    // swiftlint:disable:next function_body_length
    override func spec() {
        describe("a player") {
            var sut: Player!
            context("by default") {
                beforeEach {
                    sut = Player()
                }

                it("should have default identifier") {
                    expect(sut.id).toNot(beEmpty())
                }

                it("should have empty name") {
                    expect(sut.name).to(beEmpty())
                }

                it("should have no abilities") {
                    expect(sut.abilities).to(beEmpty())
                }

                it("should not have hand limit") {
                    expect(sut.attributes[.handLimit]) == nil
                }

                it("should have empty hand") {
                    expect(sut.hand.cards).to(beEmpty())
                }

                it("should have health == 0") {
                    expect(sut.attributes[.health]) == 0
                }

                it("should have max health == 0") {
                    expect(sut.attributes[.maxHealth]) == 0
                }

                it("should have empty inPlay") {
                    expect(sut.inPlay.cards).to(beEmpty())
                }

                it("should not have mustang") {
                    expect(sut.attributes[.mustang]) == nil
                }

                it("should not have scope") {
                    expect(sut.attributes[.scope]) == nil
                }

                it("should have weapon == 1") {
                    expect(sut.attributes[.weapon]) == 1
                }

                it("should have 2 start turn cards") {
                    expect(sut.attributes[.starTurnCards]) == 2
                }
            }

            context("initialized with identifier") {
                it("should have identifier") {
                    // Given
                    // When
                    let sut = Player("p1")

                    // Then
                    expect(sut.id) == "p1"
                }
            }

            context("initialized with abilities") {
                it("should have abilities") {
                    // Given
                    // When
                    let sut = Player {
                        Abilities {
                            "a1"
                            "a2"
                        }
                    }

                    // Then
                    expect(sut.abilities) == ["a1", "a2"]
                }
            }

            context("modified name") {
                it("should have name") {
                    // Given
                    // When
                    let sut = Player().name("p1")

                    // Then
                    expect(sut.name) == "p1"
                }
            }

            context("initialized with hand") {
                it("should have hand cards") {
                    // Given
                    // When
                    let sut = Player {
                        Hand {
                            "c1"
                            "c2"
                        }
                    }

                    // Then
                    expect(sut.hand.cards) == ["c1", "c2"]
                }
            }

            context("initialized with inPlay") {
                it("should have inPlay cards") {
                    // Given
                    // When
                    let sut = Player {
                        InPlay {
                            "c1"
                            "c2"
                        }
                    }

                    // Then
                    expect(sut.inPlay.cards) == ["c1", "c2"]
                }
            }

            context("modified attribute") {
                it("should have that attribute") {
                    // Given
                    // When
                    let sut = Player().attribute(.mustang, 1)

                    // Then
                    expect(sut.attributes[.mustang]) == 1
                }
            }

            it("should be serializable") {
                // Given
                let JSON = """
                {
                    "id": "p1",
                    "name": "n1",
                    "abilities": ["endTurn"],
                    "attributes": {
                        "maxHealth": 4,
                        "health": 2,
                        "mustang": 0,
                        "scope": 1,
                        "weapon": 3,
                        "handLimit": 2,
                        "starTurnCards": 2,
                    },
                    "hand": {
                        "visibility": "p1",
                        "cards": []
                    },
                    "inPlay": {
                        "cards": []
                    }
                }
                """
                // swiftlint:disable:next: force_unwrapping
                let jsonData = JSON.data(using: .utf8)!

                // When
                let sut = try JSONDecoder().decode(Player.self, from: jsonData)

                // Then
                expect(sut.id) == "p1"
                expect(sut.name) == "n1"
                expect(sut.abilities).to(contain(["endTurn"]))
                expect(sut.attributes[.maxHealth]) == 4
                expect(sut.attributes[.health]) == 2
                expect(sut.attributes[.handLimit]) == 2
                expect(sut.attributes[.weapon]) == 3
                expect(sut.attributes[.mustang]) == 0
                expect(sut.attributes[.scope]) == 1
                expect(sut.attributes[.starTurnCards]) == 2
            }
        }
    }
}
