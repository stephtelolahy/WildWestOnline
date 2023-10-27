//
//  SetAttributeSpec.swift
//  
//
//  Created by Hugues Telolahy on 30/08/2023.
//

import Quick
import Nimble
import Game

final class SetAttributeSpec: QuickSpec {
    override func spec() {
        describe("setting attribute") {
            it("should set attribute") {
                // Given
                let state = GameState.makeBuilder()
                    .withPlayer("p1")
                    .build()

                // When
                let action = GameAction.setAttribute(.scope, value: 1, player: "p1")
                let result = GameState.reducer(state, action)

                // Then
                expect(result.event) == action
                expect(result.player("p1").attributes[.scope]) == 1
            }
        }
    }
}
