//
//  ScopeSpec.swift
//  
//
//  Created by Hugues Telolahy on 09/09/2023.
//
import Game
import Nimble
import Quick

final class ScopeSpec: QuickSpec {
    override func spec() {
        describe("playing scope") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.scope])
                            .withAttributes([.updateAttributesOnChangeInPlay: 0])
                    }
                    .build()

                // When
                let action = GameAction.play(.scope, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.scope, player: "p1"),
                    .setAttribute(.scope, value: 1, player: "p1")
                ]
            }
        }
    }
}
