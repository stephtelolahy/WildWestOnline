//
//  StagecoachSpec.swift
//  
//
//  Created by Hugues Telolahy on 10/04/2023.
//

import Quick
import Nimble
import Game

final class StagecoachSpec: QuickSpec {
    override func spec() {
        describe("playing stagecoach") {
            it("should draw 2 cards") {
                // Given
                let state = createGameWithCardRef {
                    Player("p1") {
                        Hand {
                            .stagecoach
                        }
                    }
                    Player("p2")
                    Deck {
                        "c1"
                        "c2"
                    }
                }
                
                // When
                let action = GameAction.play(.stagecoach, actor: "p1")
                let result = self.awaitAction(action, state: state)
                
                // Then
                expect(result) == [.playImmediate(.stagecoach, actor: "p1"),
                                   .draw(player: "p1"),
                                   .draw(player: "p1")]
            }
        }
    }
}
