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

    @Test func describingPreparePlay() async throws {
        #expect(
            String(describing: GameAction.preparePlay("c1", player: "p1")) ==
            "➡️ p1 c1"
        )
    }

    @Test func describingPlayBrown() async throws {
        #expect(
            String(describing: GameAction.playBrown("c1", player: "p1")) ==
            "🟤 p1 c1"
        )
    }

    @Test func describingPlayAbility() async throws {
        #expect(
            String(describing: GameAction.playAbility("c1", player: "p1")) ==
            "🟡 p1 c1"
        )
    }

    @Test func describingPlayEquipment() async throws {
        #expect(
            String(describing: GameAction.playEquipment("c1", player: "p1")) ==
            "🔵 p1 c1"
        )
    }

    @Test func describingPlayHandicap() async throws {
        #expect(
            String(describing: GameAction.playHandicap("c1", target: "p2", player: "p1")) ==
            "🟣 p1 c1 p2"
        )
    }

    @Test func describingHeal() async throws {
        #expect(
            String(describing: GameAction.heal(1, player: "p1")) ==
            "❤️ p1"
        )

        #expect(
            String(describing: GameAction.heal(2, player: "p1")) ==
            "❤️❤️ p1"
        )
    }

    @Test func describingDamage() async throws {
        #expect(
            String(describing: GameAction.damage(1, player: "p1")) ==
            "🥵 p1"
        )

        #expect(
            String(describing: GameAction.damage(2, player: "p1")) ==
            "🥵🥵 p1"
        )
    }

    @Test func describingDrawCard() async throws {
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

    @Test func describingDiscard() async throws {
        #expect(
            String(describing: GameAction.discardHand("c1", player: "p1")) ==
            "❌ p1 c1"
        )

        #expect(
            String(describing: GameAction.discardInPlay("c1", player: "p1")) ==
            "❌ p1 c1"
        )
    }

    @Test func describingPassInPlay() async throws {
        #expect(
            String(describing: GameAction.passInPlay("c1", target: "p2", player: "p1")) ==
            "🧨 p1 p2 c1"
        )
    }

    @Test func describingRevealHand() async throws {
        #expect(
            String(describing: GameAction.showLastHand(player: "p1")) ==
            "🎲 p1"
        )
    }

    @Test func describingStartTurn() async throws {
        #expect(
            String(describing: GameAction.startTurn(player: "p1")) ==
            "🔥 p1"
        )
    }

    @Test func describingEndTurn() async throws {
        #expect(
            String(describing: GameAction.endTurn(player: "p1")) ==
            "💤 p1"
        )
    }

    @Test func describingEliminate() async throws {
        #expect(
            String(describing: GameAction.eliminate(player: "p1")) ==
            "☠️ p1"
        )
    }

    @Test func describingSetAttribute() async throws {
        #expect(
            String(describing: GameAction.setAttribute(.magnifying, value: 1, player: "p1")) ==
            "😎 p1 magnifying 1"
        )

        #expect(
            String(describing: GameAction.setAttribute(.magnifying, value: nil, player: "p1")) ==
            "😎 p1 magnifying /"
        )
    }

    @Test func describingGameOver() async throws {
        #expect(
            String(describing: GameAction.endGame(winner: "p1")) ==
            "🎉 p1"
        )
    }

    // MARK: - Game event

    @Test func describingDiscover() async throws {
        #expect(
            String(describing: GameAction.discover(3)) ==
            "🎁 3"
        )
    }

    @Test func describingDraw() async throws {
        #expect(
            String(describing: GameAction.draw) ==
            "🎲"
        )
    }

    // MARK: - Choice event

    @Test func describingChooseOne() async throws {
        #expect(
            String(describing: GameAction.chooseOne(.cardToDraw, options: ["c1", "c2"], player: "p1")) ==
            "❓ p1 c1 c2"
        )
    }

    @Test func describingActivate() async throws {
        #expect(
            String(describing: GameAction.activate(["c1", "c2"], player: "p1")) ==
            "❔ p1 c1 c2"
        )
    }

    @Test func describingEffect() async throws {
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
            "➡️ p1 discover"
        )
    }

    @Test func describingGroup() async throws {
        #expect(
            String(describing: GameAction.queue([.draw])) ==
            "➡️ [🎲]"
        )
    }

    @Test func describingPrepareChoose() async throws {
        #expect(
            String(describing: GameAction.prepareChoose("c1", player: "p1")) ==
            "➡️ p1 c1"
        )
    }
}
