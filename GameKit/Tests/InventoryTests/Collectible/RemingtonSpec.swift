//
//  RemingtonSpec.swift
//
//
//  Created by Hugues Telolahy on 18/07/2023.
//

import Quick
import Nimble
import Game

final class RemingtonSpec: QuickSpec {
    override func spec() {
        describe("playing remington") {
            it("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .remington
                        }
                    }
                    .setupAttribute(.weapon, 1)
                    .attribute(.weapon, 1)
                    .ability(.evaluateAttributeOnUpdateInPlay)
                }

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
