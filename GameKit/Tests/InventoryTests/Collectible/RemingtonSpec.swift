//
//  RemingtonSpec.swift
//
//
//  Created by Hugues Telolahy on 18/07/2023.
//

import Game
import Nimble
import Quick

final class RemingtonSpec: QuickSpec {
    override func spec() {
        describe("playing remington") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.remington])
                            .withAbilities([.updateAttributesOnChangeInPlay])
                            .withAttributes([.weapon: 1])
                    }
                    .build()

                // When
                let action = GameAction.play(.remington, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.remington, player: "p1"),
                    .setAttribute(.weapon, value: 3, player: "p1")
                ]
            }
        }
    }
}
