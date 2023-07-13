//
//  WellsFargoSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Quick
import Nimble
import Game

final class WellsFargoSpec: QuickSpec {
    override func spec() {
        describe("playing wellsFargo") {
            it("should draw 3 cards") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .wellsFargo
                        }
                    }
                    Player("p2")
                    Deck {
                        "c1"
                        "c2"
                        "c3"
                    }
                }
                
                // When
                let action = GameAction.play(.wellsFargo, actor: "p1")
                let result = self.awaitAction(action, state: state)
                
                // Then
                expect(result) == [.playImmediate(.wellsFargo, actor: "p1"),
                                   .draw(player: "p1"),
                                   .draw(player: "p1"),
                                   .draw(player: "p1")]
            }
        }
    }
}
