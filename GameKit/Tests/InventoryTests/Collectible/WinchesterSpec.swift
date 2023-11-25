//
//  WinchesterSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/09/2023.
//
import Game
import Nimble
import Quick

final class WinchesterSpec: QuickSpec {
    override func spec() {
        describe("playing winchester") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.winchester])
                            .withAttributes([.updateAttributesOnChangeInPlay: 0, .weapon: 1])
                            .withFigure(.pDefault)
                    }
                    .build()

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
