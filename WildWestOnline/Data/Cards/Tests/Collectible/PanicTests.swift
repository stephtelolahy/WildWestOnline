//
//  PanicTests.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 06/01/2024.
//

import GameCore
import Testing

struct PanicTests {
    @Test func playing_Panic_noPlayerAllowed_shouldThrowError() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .build()
        
        // When
        // Then
        let action = GameAction.preparePlay(.panic, player: "p1")
        await #expect(throws: ArgPlayer.Error.noPlayer(.selectAt(1))) {
            try await dispatch(action, state: state)
        }
    }
    
    @Test func playing_Panic_targetIsOther_havingHandCards_shouldChooseOneHandCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
            }
            .build()
        
        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", "hiddenHand-0"])
        
        // Then
        #expect(result == [
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToSteal, options: ["hiddenHand-0"], player: "p1"),
            .stealHand("c21", target: "p2", player: "p1")
        ])
    }
    
    @Test func playing_Panic_targetIsOther_havingInPlayCards_shouldChooseInPlayCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withInPlay(["c21", "c22"])
            }
            .build()
        
        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", "c22"])
        
        // Then
        #expect(result == [
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToSteal, options: ["c21", "c22"], player: "p1"),
            .stealInPlay("c22", target: "p2", player: "p1")
        ])
    }
    
    @Test func playing_Panic_targetIsOther_havingHandAndInPlayCards_shouldChooseAnyCard() async throws {
        // Given
        let state = GameState.makeBuilderWithCards()
            .withPlayer("p1") {
                $0.withHand([.panic])
            }
            .withPlayer("p2") {
                $0.withHand(["c21"])
                    .withInPlay(["c22", "c23"])
            }
            .build()
        
        // When
        let action = GameAction.preparePlay(.panic, player: "p1")
        let result = try await dispatch(action, state: state, choose: ["p2", "c23"])
        
        // Then
        #expect(result == [
            .playBrown(.panic, player: "p1"),
            .chooseOne(.target, options: ["p2"], player: "p1"),
            .chooseOne(.cardToSteal, options: ["c22", "c23", "hiddenHand-0"], player: "p1"),
            .stealInPlay("c23", target: "p2", player: "p1")
        ])
    }
}
