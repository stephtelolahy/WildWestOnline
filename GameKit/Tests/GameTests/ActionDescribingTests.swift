//
//  ActionDescribingTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

import Game
import XCTest

final class ActionDescribingTests: XCTestCase {
    func test_DescribingPlayIntent() {
        XCTAssertEqual(
            String(describing: GameAction.play("c1", player: "p1")),
            "▶️ p1 c1"
        )
    }

    func test_DescribingPlayWithoutTarget() {
        XCTAssertEqual(
            String(describing: GameAction.playImmediate("c1", player: "p1")),
            "✅ p1 c1"
        )

        XCTAssertEqual(
            String(describing: GameAction.playAs("a1", card: "c1", player: "p1")),
            "✅ p1 a1"
        )

        XCTAssertEqual(
            String(describing: GameAction.playEquipment("c1", player: "p1")),
            "✅ p1 c1"
        )
    }

    func test_DescribingPlayWithTarget() {
        XCTAssertEqual(
            String(describing: GameAction.playImmediate("c1", target: "p2", player: "p1")),
            "❇️ p1 c1 p2"
        )

        XCTAssertEqual(
            String(describing: GameAction.playAs("a1", card: "c1", target: "p2", player: "p1")),
            "❇️ p1 a1 p2"
        )

        XCTAssertEqual(
            String(describing: GameAction.playHandicap("c1", target: "p2", player: "p1")),
            "❇️ p1 c1 p2"
        )
    }
}
