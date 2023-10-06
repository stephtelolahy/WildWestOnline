//
//  WinchesterSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/09/2023.
//
import Quick
import Nimble
import Game

final class WinchesterSpec: QuickSpec {
    override func spec() {
        describe("playing winchester") {
            it("should equip") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .winchester
                        }
                    }
                    .setupAttribute(.weapon, 1)
                    .attribute(.weapon, 1)
                    .ability(.evaluateAttributeOnUpdateInPlay)
                }

                // When
                let action = GameAction.play(.winchester, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.winchester, player: "p1"),
                    .setAttribute(.weapon, value: 5, player: "p1")
                ]
            }
        }
    }
}
