//
//  CardLocationSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Quick
import Nimble
import Game
import Foundation

final class CardLocationSpec: QuickSpec {
    override func spec() {
        describe("a card location") {
            var sut: CardLocation!
            context("by default") {
                beforeEach {
                    sut = CardLocation(cards: [])
                }
                
                it("should be empty") {
                    expect(sut.cards).to(beEmpty())
                }
                
                it("should be visible to everyone") {
                    expect(sut.hidden) == false
                }
            }
            
            context("initialized with visibility") {
                it("should have limited visibility") {
                    // Given
                    // When
                    let sut = CardLocation(cards: [], hidden: true)

                    // Then
                    expect(sut.hidden) == true
                }
            }
            
            context("initialized with cards") {
                it("should have correct count") {
                    // Given
                    // When
                    let sut = CardLocation(cards: ["c1"])
                    
                    // Then
                    expect(sut.count) == 1
                }
                
                it("should have cards") {
                    // Given
                    // When
                    let sut = CardLocation(cards: ["c1", "c2"])
                    
                    // Then
                    expect(sut.cards) == ["c1", "c2"]
                }
            }

            it("should be serializable") {
                // Given
                let JSON = """
                {
                    "hidden": true,
                    "cards": [
                        "c1",
                        "c2"
                    ]
                }
                """
                // swiftlint:disable:next: force_unwrapping
                let jsonData = JSON.data(using: .utf8)!

                // When
                let sut = try JSONDecoder().decode(CardLocation.self, from: jsonData)

                // Then
                expect(sut.hidden) == true
                expect(sut.cards) == ["c1", "c2"]
            }
        }
    }
}
