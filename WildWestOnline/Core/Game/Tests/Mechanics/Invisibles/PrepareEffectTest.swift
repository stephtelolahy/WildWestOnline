//
//  PrepareEffectTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 22/09/2024.
//

import Testing
@testable import GameCore

struct PrepareEffectTest {
    @Test func prepareEffect_playBrown() async throws {
        // Given
        let state = GameState.makeBuilder()
            .build()

        // When
        let action = GameAction.prepareEffect(
            .init(
                action: .playBrown,
                card: "c1",
                actor: "p1"
            )
        )
        let result = try GameState.reducer(state, action)

        // Then
        #expect(result.sequence.queue.first == .playBrown("c1", player: "p1"))
    }
    /*
     /// {actor} put a {card} is self's inPlay
     case playEquipment

     /// {actor} put a {card} on {target}'s inPlay
     case playHandicap

     /// {target} increase health by {amount}
     /// By default target is {actor}
     /// By default heal amount is 1
     case heal

     /// {target} decrease health by {amount}
     /// By default target is {actor}
     /// By default damage amount is 1
     case damage

     /// {actor} draw the top deck card
     /// When a {card} is specified, this allow to draw a specific card
     case drawDeck

     /// {actor} draws the last discarded card
     /// When a {card} is specified, this allow to draw a specific card
     case drawDiscard

     /// {actor} steal a {card} from {target}
     case steal

     /// {target} discard a {card}
     /// By default target is {actor}
     case discard

     /// {actor} pass inPlay {card} on {target}'s inPlay
     case passInPlay

     /// draw {drawCards} cards from deck. Next effects depend on it
     case draw

     /// {actor} shows his last drawn card
     case showLastHand

     /// expose {amount} choosable cards from top deck
     case discover

     /// draw discovered deck {card}
     case drawDiscovered

     /// hide discovered cards
     case undiscover

     /// {target} starts his turn
     case startTurn

     /// {actor} ends his turn
     case endTurn

     /// {actor} gets eliminated
     case eliminate

     // MARK: - To spec

     /// {actor} shoot at {target} with {damage} and {requiredMisses}
     /// By default damage is 1
     /// By default requiredMisses is 1
     case shoot

     /// {actor} counter a shot applied on himself
     case missed

     /// Counter card effect targetting self
     case counter
     */
}
