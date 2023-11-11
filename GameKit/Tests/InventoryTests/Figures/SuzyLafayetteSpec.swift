//
//  SuzyLafayetteSpec.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 09/11/2023.
//

import Quick
import Nimble
import Game

final class SuzyLafayetteSpec: QuickSpec {
    override func spec() {
        describe("SuzyLafayette having no hand cards") {
            it("should draw a card") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withAttributes([.suzyLafayette: 0])
                            .withHand(["c1"])
                    }
                    .withDeck(["c2"])
                    .build()

                // When
                let action = GameAction.discardHand("c1", player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [
                    .discardHand("c1", player: "p1"),
                    .draw(player: "p1")
                ]
            }
        }
    }
}

