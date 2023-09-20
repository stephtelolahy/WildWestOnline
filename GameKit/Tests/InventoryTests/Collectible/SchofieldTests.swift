//
//  SchofieldTests.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 15/09/2023.
//

import XCTest
import Game

final class SchofieldTests: XCTestCase {

    func test_PlayingSchofield_NoWeaponInPlay_ShouldEquip() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    .schofield
                }
            }
            .attribute(.weapon, 1)
            .setupAttribute(.weapon, 1)
        }

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let result = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1")
        ])
    }

    func test_PlayingSchofield_AlreadyPlayingAnotherWeapon_ShouldDiscardPreviousWeapon() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    .schofield
                }
                InPlay {
                    .remington
                }
            }
            .attribute(.weapon, 3)
            .setupAttribute(.weapon, 1)
            .ability(.discardPreviousWeaponOnPlayWeapon)
        }

        // When
        let action = GameAction.play(.schofield, player: "p1")
        let result = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .playEquipment(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 2, player: "p1"),
            .discardInPlay(.remington, player: "p1")
        ])
    }

    func test_discardingSchofield_FromInPlay_shouldResetToDefaultWeapon() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                InPlay {
                    .schofield
                }
            }
            .attribute(.weapon, 2)
            .setupAttribute(.weapon, 1)
        }

        // When
        let action = GameAction.discardInPlay(.schofield, player: "p1")
        let result = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardInPlay(.schofield, player: "p1"),
            .setAttribute(.weapon, value: 1, player: "p1")
        ])
    }

    func test_discardingSchofield_FromHand_shouldDoNothing() {
        // Given
        let state = createGameWithCardRef {
            Player("p1") {
                Hand {
                    .schofield
                }
            }
        }

        // When
        let action = GameAction.discardHand(.schofield, player: "p1")
        let result = self.awaitAction(action, state: state)

        // Then
        XCTAssertEqual(result, [
            .discardHand(.schofield, player: "p1")
        ])
    }
}
