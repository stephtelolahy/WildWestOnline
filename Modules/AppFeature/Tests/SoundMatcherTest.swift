//
//  SoundMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

@testable import AppFeature
import Testing
import GameFeature

struct SoundMatcherTest {
    private let sut = SoundMatcher(specialSounds: [:])

    @Test func soundOnEquip() async throws {
        // Given
        let event = GameFeature.Action.equip("c1", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxShotGun)
    }

    @Test func soundOnHandicap() async throws {
        // Given
        let event = GameFeature.Action.handicap("c1", target: "p2", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxMetalLatch)
    }

    @Test func soundOnDrawDeck() async throws {
        // Given
        let event = GameFeature.Action.drawDeck(player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }

    @Test func soundOnDraw() async throws {
        // Given
        let event = GameFeature.Action.draw(player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }

    @Test func soundOnStealHand() async throws {
        // Given
        let event = GameFeature.Action.stealHand("c1", target: "p2", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlap)
    }

    @Test func soundOnStealInPlay() async throws {
        // Given
        let event = GameFeature.Action.stealInPlay("c1", target: "p2", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlap)
    }

    @Test func soundOnDrawDiscovered() async throws {
        // Given
        let event = GameFeature.Action.drawDiscovered("c1", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }

    @Test func soundOnDrawDiscard() async throws {
        // Given
        let event = GameFeature.Action.drawDiscard(player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }

    @Test func soundOnPassInPlay() async throws {
        // Given
        let event = GameFeature.Action.passInPlay("c1", target: "p2", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxFuseBurning)
    }

    @Test func soundOnDiscardHand() async throws {
        // Given
        let event = GameFeature.Action.discardHand("c1", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxFly)
    }

    @Test func soundOnDiscardInPlay() async throws {
        // Given
        let event = GameFeature.Action.discardInPlay("c1", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxFly)
    }

    @Test func soundOnDiscover() async throws {
        // Given
        let event = GameFeature.Action.discover()

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }

    @Test func soundOnShowHand() async throws {
        // Given
        let event = GameFeature.Action.showHand("c1", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxSlideClosed)
    }
}
