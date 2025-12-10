//
//  AIStrategyTest.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 27/12/2024.
//

import Testing
import GameCore
import CardResources

struct AIStrategyTest {
    @Test func evaluateBestMove_amongPlayingCard() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .withPlayer("p1")
            .build()
        let possibleMoves: [GameFeature.Action] = [
            .preparePlay(.endTurn, player: "p1"),
            .preparePlay(.panic, player: "p1"),
            .preparePlay(.bang, player: "p1")
        ]
        let sut = AIStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .preparePlay(.bang, player: "p1"))
    }

    @Test func evaluateBestMove_amongChoosingAnItem() async throws {
        // Given
        let state = GameFeature.State.makeBuilder()
            .withAllCards()
            .build()
        let possibleMoves: [GameFeature.Action] = [
            .choose(.choicePass, player: "p1"),
            .choose(.missed, player: "p1")
        ]
        let sut = AIStrategy()

        // When
        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        // Then
        #expect(bestMove == .choose(.missed, player: "p1"))
    }
}
