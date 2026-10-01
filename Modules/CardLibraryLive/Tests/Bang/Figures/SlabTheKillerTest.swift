//
//  SlabTheKillerTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 29/05/2024.
//

import GameCore
import Testing

struct SlabTheKillerTest {
    @Test func playingBang_withTwoMissed() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2", hand: [.missed1, .missed2])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state)

        #expect(
            result == [
                .preparePlay(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed1, player: "p2"),
                .play(.missed1, player: "p2", target: "p2"),
                .counterShoot(player: "p2"),
                .choose(.missed2, player: "p2"),
                .play(.missed2, player: "p2", target: "p2"),
                .counterShoot(player: "p2")
            ])
    }

    @Test func playingBang_withSuccessfulBarrelAndMissed() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2", hand: [.missed], inPlay: [.barrel])
            .withDeck(["c1-2♥️"])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state)

        #expect(
            result == [
                .preparePlay(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .draw(player: "p2"),
                .counterShoot(player: "p2"),
                .choose(.missed, player: "p2"),
                .play(.missed, player: "p2", target: "p2"),
                .counterShoot(player: "p2")
            ])
    }

    @Test func playingBang_withOneMissed_shouldDamage() async throws {
        let state = GameFeature.State.makeBuilder()
            .withAllCardsAndAuras()
            .withPlayer("p1") {
                $0.withFigure([.slabTheKiller])
                    .withHand([.bang])
                    .withWeapon(1)
            }
            .withPlayer("p2", health: 2, hand: [.missed])
            .build()

        let result = try await dispatchUntilCompleted(.preparePlay(.bang, player: "p1"), state: state, ignoreError: true)

        #expect(
            result == [
                .preparePlay(.bang, player: "p1"),
                .choose("p2", player: "p1"),
                .play(.bang, player: "p1", target: "p2"),
                .shoot("p2"),
                .choose(.missed, player: "p2"),
                .play(.missed, player: "p2", target: "p2"),
                .counterShoot(player: "p2"),
                .damage(1, player: "p2")
            ])
    }
}
