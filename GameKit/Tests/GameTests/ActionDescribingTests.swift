//
//  ActionDescribingTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//
// swiftlint:disable no_magic_numbers

import Game
import XCTest

final class ActionDescribingTests: XCTestCase {
    // MARK: - Player event

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
            String(describing: GameAction.playAbility("c1", player: "p1")),
            "✅ p1 c1"
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

    func test_DescribingHeal() {
        XCTAssertEqual(
            String(describing: GameAction.heal(1, player: "p1")),
            "❤️ p1"
        )

        XCTAssertEqual(
            String(describing: GameAction.heal(2, player: "p1")),
            "❤️❤️ p1"
        )
    }

    func test_DescribingDamage() {
        XCTAssertEqual(
            String(describing: GameAction.damage(1, player: "p1")),
            "🥵 p1"
        )

        XCTAssertEqual(
            String(describing: GameAction.damage(2, player: "p1")),
            "🥵🥵 p1"
        )
    }

    func test_DescribingDrawCard() {
        XCTAssertEqual(
            String(describing: GameAction.drawDeck(player: "p1")),
            "💰 p1"
        )

        XCTAssertEqual(
            String(describing: GameAction.drawArena("c1", player: "p1")),
            "💰 p1 c1"
        )

        XCTAssertEqual(
            String(describing: GameAction.drawDiscard(player: "p1")),
            "💰 p1"
        )

        XCTAssertEqual(
            String(describing: GameAction.drawHand("c1", target: "p2", player: "p1")),
            "‼️ p1 c1 p2"
        )

        XCTAssertEqual(
            String(describing: GameAction.drawInPlay("c1", target: "p2", player: "p1")),
            "‼️ p1 c1 p2"
        )
    }

    func test_DescribingDiscard() {
        XCTAssertEqual(
            String(describing: GameAction.discardHand("c1", player: "p1")),
            "❌ p1 c1"
        )

        XCTAssertEqual(
            String(describing: GameAction.discardInPlay("c1", player: "p1")),
            "❌ p1 c1"
        )
    }

    func test_DescribingPassInPlay() {
        XCTAssertEqual(
            String(describing: GameAction.passInPlay("c1", target: "p2", player: "p1")),
            "🧨 p1 -> p2 c1"
        )
    }

    func test_DescribingRevealHand() {
        XCTAssertEqual(
            String(describing: GameAction.revealHand("c1", player: "p1")),
            "🎲 p1 c1"
        )
    }

    func test_DescribingSetTurn() {
        XCTAssertEqual(
            String(describing: GameAction.setTurn("p1")),
            "🔥 p1"
        )
    }

    func test_DescribingEliminate() {
        XCTAssertEqual(
            String(describing: GameAction.eliminate(player: "p1")),
            "☠️ p1"
        )
    }

    func test_DescribingSetAttribute() {
        XCTAssertEqual(
            String(describing: GameAction.setAttribute(.bangsPerTurn, value: 1, player: "p1")),
            "😎 p1 bangsPerTurn 1"
        )

        XCTAssertEqual(
            String(describing: GameAction.removeAttribute(.bangsPerTurn, player: "p1")),
            "😕 p1 bangsPerTurn X"
        )
    }

    func test_DescribingGameOver() {
        XCTAssertEqual(
            String(describing: GameAction.setGameOver(winner: "p1")),
            "🎉 p1"
        )
    }

    // MARK: - Game event

    func test_DescribingDiscover() {
        XCTAssertEqual(
            String(describing: GameAction.discover),
            "🌁"
        )
    }

    func test_DescribingPutBack() {
        XCTAssertEqual(
            String(describing: GameAction.putBack),
            "🌁"
        )
    }

    func test_DescribingDraw() {
        XCTAssertEqual(
            String(describing: GameAction.draw),
            "🎲"
        )
    }

    func test_DescribingCancel() {
        XCTAssertEqual(
            String(describing: GameAction.cancel(.nothing)),
            "✋ \(String(describing: GameAction.nothing))"
        )
    }

    // MARK: - Choice event

    func test_DescribingChooseOne() {
        XCTAssertEqual(
            String(describing: GameAction.chooseOne(player: "p1", options: ["o1": .nothing])),
            "❓ p1 o1"
        )
    }

    func test_DescribingActivate() {
        XCTAssertEqual(
            String(describing: GameAction.activate(["c1", "c2"], player: "p1")),
            "❓ p1 c1 c2"
        )
    }

    func test_DescribingEffect() {
        XCTAssertEqual(
            String(describing: GameAction.effect(.discover, ctx: .init(actor: "p1", card: "c1", event: .nothing))),
            "➡️ p1 discover"
        )

        XCTAssertEqual(
            String(describing: GameAction.effect(.damage(3), ctx: .init(actor: "p1", card: "c1", event: .nothing))),
            "➡️ p1 damage(3)"
        )
    }

    func test_DescribingGroup() {
        XCTAssertEqual(
            String(describing: GameAction.group([.draw])),
            "➡️ group [🎲]"
        )
    }
}
