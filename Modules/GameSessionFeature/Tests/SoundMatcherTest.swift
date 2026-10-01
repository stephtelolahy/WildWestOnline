//
//  SoundMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

import Testing
import GameCore
@testable import GameSessionFeature

struct SoundMatcherTest {
    private let sut = SoundMatcher(specialSounds: [:])

    @Test(arguments: [
        (.equip("c1", player: "p1"), .sfxShotGun),
        (.handicap("c1", target: "p2", player: "p1"), .sfxMetalLatch),
        (.drawDeck(player: "p1"), .sfxSlideClosed),
        (.draw(player: "p1"), .sfxSlideClosed),
        (.stealHand("c1", target: "p2", player: "p1"), .sfxSlap),
        (.stealInPlay("c1", target: "p2", player: "p1"), .sfxSlap),
        (.drawDiscovered("c1", player: "p1"), .sfxSlideClosed),
        (.drawDiscard("c1", player: "p1"), .sfxSlideClosed),
        (.passInPlay("c1", target: "p2", player: "p1"), .sfxFuseBurning),
        (.discardHand("c1", player: "p1"), .sfxFly),
        (.discardInPlay("c1", player: "p1"), .sfxFly),
        (.discover(), .sfxSlideClosed),
        (.showHand("c1", player: "p1"), .sfxSlideClosed)
    ] as [(GameFeature.Action, String)])
    func soundOnEvent(event: GameFeature.Action, expected: String) {
        #expect(sut.sfx(on: event) == expected)
    }
}
