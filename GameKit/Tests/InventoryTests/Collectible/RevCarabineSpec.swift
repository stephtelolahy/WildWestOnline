//
//  RevCarabineSpec.swift
//  
//
//  Created by Hugues Telolahy on 08/09/2023.
//
import Quick
import Nimble
import Game

final class RevCarabineSpec: QuickSpec {
    override func spec() {
        describe("playing revCarabine") {
            it("should equip") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.revCarabine])
                            .withStartAttributes([.weapon: 1])
                            .withAttributes([.weapon: 1])
                            .withAbilities([.evaluateAttributeOnUpdateInPlay])
                    }
                    .build()

                // When
                let action = GameAction.play(.revCarabine, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .playEquipment(.revCarabine, player: "p1"),
                    .setAttribute(.weapon, value: 4, player: "p1")
                ]
            }
        }
    }
}
