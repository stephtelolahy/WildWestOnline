//
//  SchofieldSpec.swift
//  
//
//  Created by Hugues Telolahy on 17/07/2023.
//

import Quick
import Nimble
import Game

final class SchofieldSpec: QuickSpec {
    override func spec() {
        describe("playing schofield") {
            xit("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .schofield
                        }
                    }
                }

                // When
                let action = GameAction.play(.schofield, actor: "p1")
                let result = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.schofield, actor: "p1"),
                    .setAttribute(.weapon, value: 2, player: "p1")
                ]
            }
        }
    }
}
