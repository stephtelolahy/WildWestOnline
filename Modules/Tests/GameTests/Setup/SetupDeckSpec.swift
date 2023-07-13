//
//  SetupDeckSpec.swift
//  
//
//  Created by Hugues Telolahy on 19/05/2023.
//

import Quick
import Nimble
import Game

final class SetupDeckSpec: QuickSpec {
    override func spec() {
        describe("setup a deck") {
            it("should create cards by combining name and values") {
                // Given
                let cardSets: [String: [String]] = [
                    "card1": ["val11", "val12"],
                    "card2": ["val21", "val22"]
                ]

                // When
                let deck = Setup.createDeck(cardSets: cardSets)

                // Then
                expect(deck).to(contain([
                    "card1-val11",
                    "card1-val12",
                    "card2-val21",
                    "card2-val22"
                ]))
            }
        }
    }
}
