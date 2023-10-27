//
//  MustangSpec.swift
//
//
//  Created by Hugues Telolahy on 09/09/2023.
//

import Quick
import Nimble
import Game

final class MustangSpec: QuickSpec {
    override func spec() {
        describe("playing mustang") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.mustang])
                            .withStartAttributes([.mustang: 0])
                            .withAttributes([.mustang: 0])
                            .withAbilities([.evaluateAttributeOnUpdateInPlay])
                    }
                    .build()

                // When
                let action = GameAction.play(.mustang, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.mustang, player: "p1"),
                    .setAttribute(.mustang, value: 1, player: "p1")
                ]
            }
        }
    }
}
