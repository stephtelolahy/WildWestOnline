//
//  WellsFargoSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Game
import Nimble
import Quick

final class WellsFargoSpec: QuickSpec {
    override func spec() {
        describe("playing wellsFargo") {
            it("should draw 3 cards") {
                // Given
                let state = GameState.makeBuilderWithCardRef()
                    .withPlayer("p1") {
                        $0.withHand([.wellsFargo])
                    }
                    .withPlayer("p2")
                    .withDeck(["c1", "c2", "c3"])
                    .build()

                // When
                let action = GameAction.play(.wellsFargo, player: "p1")
                let (result, _) = self.awaitAction(action, state: state)

                // Then
                expect(result) == [.playImmediate(.wellsFargo, player: "p1"),
                                   .draw(player: "p1"),
                                   .draw(player: "p1"),
                                   .draw(player: "p1")]
            }
        }
    }
}
