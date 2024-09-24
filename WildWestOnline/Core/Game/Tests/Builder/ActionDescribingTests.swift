//
//  ActionDescribingTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

import Testing
@testable import GameCore

struct ActionDescribingTests {
    // MARK: - Player event

    func test_DescribingPreparePlay() {
        #expect(
            String(describing: GameAction.preparePlay("c1", player: "p1")) ==
            "➡️ p1 c1"
        )
    }

    func test_DescribingPlayBrown() {
        #expect(
            String(describing: GameAction.playBrown("c1", player: "p1")) ==
            "🟤 p1 c1"
        )
    }

    func test_DescribingPlayAbility() {
        #expect(
            String(describing: GameAction.playAbility("c1", player: "p1")) ==
            "🟡 p1 c1"
        )
    }

    func test_DescribingPlayEquipment() {
        #expect(
            String(describing: GameAction.playEquipment("c1", player: "p1")) ==
            "🔵 p1 c1"
        )
    }

    func test_DescribingPlayHandicap() {
        #expect(
            String(describing: GameAction.playHandicap("c1", target: "p2", player: "p1")) ==
            "🟣 p1 c1 p2"
        )
    }

    func test_DescribingHeal() {
        #expect(
            String(describing: GameAction.heal(1, player: "p1")) ==
            "❤️ p1"
        )

        #expect(
            String(describing: GameAction.heal(2, player: "p1")) ==
            "❤️❤️ p1"
        )
    }

    func test_DescribingDamage() {
        #expect(
            String(describing: GameAction.damage(1, player: "p1")) ==
            "🥵 p1"
        )

        #expect(
            String(describing: GameAction.damage(2, player: "p1")) ==
            "🥵🥵 p1"
        )
    }

    func test_DescribingDrawCard() {
        #expect(
            String(describing: GameAction.drawDeck(player: "p1")) ==
            "💰 p1"
        )

        #expect(
            String(describing: GameAction.drawDiscard(player: "p1")) ==
            "💰 p1"
        )

        #expect(
            String(describing: GameAction.stealHand("c1", target: "p2", player: "p1")) ==
            "‼️ p1 c1 p2"
        )

        #expect(
            String(describing: GameAction.stealInPlay("c1", target: "p2", player: "p1")) ==
            "‼️ p1 c1 p2"
        )
    }

    func test_DescribingDiscard() {
        #expect(
            String(describing: GameAction.discardHand("c1", player: "p1")) ==
            "❌ p1 c1"
        )

        #expect(
            String(describing: GameAction.discardInPlay("c1", player: "p1")) ==
            "❌ p1 c1"
        )
    }

    func test_DescribingPassInPlay() {
        #expect(
            String(describing: GameAction.passInPlay("c1", target: "p2", player: "p1")) ==
            "🧨 p1 p2 c1"
        )
    }

    func test_DescribingRevealHand() {
        #expect(
            String(describing: GameAction.showLastHand(player: "p1")) ==
            "🎲 p1"
        )
    }

    func test_DescribingStartTurn() {
        #expect(
            String(describing: GameAction.startTurn(player: "p1")) ==
            "🔥 p1"
        )
    }

    func test_DescribingEndTurn() {
        #expect(
            String(describing: GameAction.endTurn(player: "p1")) ==
            "💤 p1"
        )
    }

    func test_DescribingEliminate() {
        #expect(
            String(describing: GameAction.eliminate(player: "p1")) ==
            "☠️ p1"
        )
    }

    func test_DescribingSetAttribute() {
        #expect(
            String(describing: GameAction.setAttribute(.magnifying, value: 1, player: "p1")) ==
            "😎 p1 magnifying 1"
        )

        #expect(
            String(describing: GameAction.setAttribute(.magnifying, value: nil, player: "p1")) ==
            "😎 p1 magnifying /"
        )
    }

    func test_DescribingGameOver() {
        #expect(
            String(describing: GameAction.endGame(winner: "p1")) ==
            "🎉 p1"
        )
    }

    // MARK: - Game event

    func test_DescribingDiscover() {
        #expect(
            String(describing: GameAction.discover(3)) ==
            "🎁 3"
        )
    }

    func test_DescribingDraw() {
        #expect(
            String(describing: GameAction.draw) ==
            "🎲"
        )
    }

    // MARK: - Choice event

    func test_DescribingChooseOne() {
        #expect(
            String(describing: GameAction.chooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")) ==
            "❓ p1 c1 c2"
        )
    }

    func test_DescribingActivate() {
        #expect(
            String(describing: GameAction.activate(["c1", "c2"], player: "p1")) ==
            "❔ p1 c1 c2"
        )
    }

    func test_DescribingEffect() {
        #expect(
            String(
                describing: GameAction.prepareEffect(
                    .init(
                        action: .discover,
                        card: "c1",
                        actor: "p1"
                    )
                )
            ) ==
            "➡️ discover"
        )
    }

    func test_DescribingGroup() {
        #expect(
            String(describing: GameAction.queue([.draw])) ==
            "➡️ [🎲]"
        )
    }

    func test_DescribingPrepareChoose() {
        #expect(
            String(describing: GameAction.prepareChoose("c1", player: "p1")) ==
            "➡️ p1 c1"
        )
    }
}
