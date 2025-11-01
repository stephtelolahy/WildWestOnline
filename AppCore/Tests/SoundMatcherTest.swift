//
//  SoundMatcherTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 17/10/2025.
//

@testable import AppCore
import Testing
import GameFeature

struct SoundMatcherTest {

    private let sut = SoundMatcher()

    @Test func soundOnPlayStagecoach() async throws {
        // Given
        let event = GameFeature.Action.play("stagecoach", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxHorseGalloping)
    }

    @Test func soundOnPlayWellsFargo() async throws {
        // Given
        let event = GameFeature.Action.play("wellsFargo", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxHorseGalloping)
    }

    @Test func soundOnPlayDuel() async throws {
        // Given
        let event = GameFeature.Action.play("duel", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxShotgunOldSchool)
    }

    @Test func soundOnPlayGatling() async throws {
        // Given
        let event = GameFeature.Action.play("gatling", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxAutomaticMachineGun)
    }

    @Test func soundOnPlayIndians() async throws {
        // Given
        let event = GameFeature.Action.play("indians", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxPeacock)
    }

    @Test func soundOnPlayBrawl() async throws {
        // Given
        let event = GameFeature.Action.play("brawl", player: "p1")

        // When
        let sound = try #require(sut.sfx(on: event))

        // Then
        #expect(sound == .sfxPeacock)
    }

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
        let event = GameFeature.Action.draw()

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
}
