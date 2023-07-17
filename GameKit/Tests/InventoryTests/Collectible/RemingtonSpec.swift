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
                }

                // When
                let action = GameAction.play(.remington, actor: "p1")
                let result = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.remington, actor: "p1")
                ]
            }
        }
    }
}
