//
//  ActionDescribingTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

@testable import GameCore
import XCTest

final class ActionDescribingTests: XCTestCase {
    // MARK: - Player event

    func test_DescribingPlay() {
        XCTAssertEqual(
            String(describing: GameAction.play("c1", player: "p1")),
            "✅ p1 c1"
        )
    }

    func test_DescribingEquip() {
        XCTAssertEqual(
            String(describing: GameAction.equip("c1", player: "p1")),
            "💼 p1 c1"
        )
    }

    func test_DescribingHandicap() {
        XCTAssertEqual(
            String(describing: GameAction.handicap("c1", target: "p2", player: "p1")),
            "🚫 p1 c1 p2"
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

        XCTAssertEqual(
            String(describing: GameAction.discardPlayed("c1", player: "p1")),
            "❌ p1 c1"
        )
    }

    func test_DescribingPassInPlay() {
        XCTAssertEqual(
            String(describing: GameAction.passInPlay("c1", target: "p2", player: "p1")),
            "🧨 p1 p2 c1"
        )
    }

    func test_DescribingRevealHand() {
        XCTAssertEqual(
            String(describing: GameAction.revealHand("c1", player: "p1")),
            "🎲 p1 c1"
        )
    }

    func test_DescribingStartTurn() {
        XCTAssertEqual(
            String(describing: GameAction.startTurn(player: "p1")),
            "🔥 p1"
        )
    }

    func test_DescribingEndTurn() {
        XCTAssertEqual(
            String(describing: GameAction.endTurn(player: "p1")),
            "💤 p1"
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
            String(describing: GameAction.setAttribute(.magnifying, value: 1, player: "p1")),
            "😎 p1 magnifying 1"
        )

        XCTAssertEqual(
            String(describing: GameAction.removeAttribute(.magnifying, player: "p1")),
            "😕 p1 magnifying"
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
            "🎁"
        )
    }

    func test_DescribingDraw() {
        XCTAssertEqual(
            String(describing: GameAction.draw),
            "🎲"
        )
    }

    // MARK: - Choice event

    func test_DescribingChooseOne() {
        XCTAssertEqual(
            String(describing: GameAction.chooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")),
            "❓ p1 c1 c2"
        )

        XCTAssertEqual(
            String(describing: GameAction.choose("c1", player: "p1")),
            "👉 p1 c1"
        )
    }

    func test_DescribingActivate() {
        XCTAssertEqual(
            String(describing: GameAction.activate(["c1", "c2"], player: "p1")),
            "❔ p1 c1 c2"
        )
    }

    func test_DescribingEffect() {
        XCTAssertEqual(
            String(describing: GameAction.effect(.discover, ctx: .init(sourceEvent: .nothing, sourceActor: "p1", sourceCard: "c1"))),
            "➡️ discover"
        )

        XCTAssertEqual(
            String(describing: GameAction.effect(.damage(3), ctx: .init(sourceEvent: .nothing, sourceActor: "p1", sourceCard: "c1"))),
            "➡️ damage(3)"
        )
    }

    func test_DescribingGroup() {
        XCTAssertEqual(
            String(describing: GameAction.group([.draw])),
            "➡️ group [🎲]"
        )
    }
}
