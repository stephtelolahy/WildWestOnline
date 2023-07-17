//
//  CardSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Quick
import Nimble
import Game
import Foundation

final class CardSpec: QuickSpec {
    override func spec() {
        describe("a card") {
            var sut: Card!
            context("initialized") {
                beforeEach {
                    sut = Card("c1")
                }
                
                it("should have a name") {
                    expect(sut.name) == "c1"
                }
            }

            it("should be serializable") {
                // Given
                let JSON = """
                {
                    "name": "c1",
                    "type": "immediate",
                    "actions": []
                }
                """
                // swiftlint:disable:next: force_unwrapping
                let jsonData = JSON.data(using: .utf8)!

                // When
                let sut = try JSONDecoder().decode(Card.self, from: jsonData)

                // Then
                expect(sut.name) == "c1"
                expect(sut.type) == .immediate
            }
        }
    }
}
