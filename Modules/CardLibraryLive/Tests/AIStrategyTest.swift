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
        let state = GameFeature.State.makeBuilderWithAllCards()
            .withPlayer("p1")
            .build()
        let possibleMoves: [GameFeature.Action] = [
            .preparePlay(.endTurn, player: "p1"),
            .preparePlay(.panic, player: "p1"),
            .preparePlay(.bang, player: "p1")
        ]
        let sut = AIStrategy()

        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        #expect(bestMove == .preparePlay(.bang, player: "p1"))
    }

    @Test func evaluateBestMove_amongChoosingAnItem() async throws {
        let state = GameFeature.State.makeBuilderWithAllCards()
            .build()
        let possibleMoves: [GameFeature.Action] = [
            .choose(.choicePass, player: "p1"),
            .choose(.missed, player: "p1")
        ]
        let sut = AIStrategy()

        let bestMove = sut.evaluateBestMove(possibleMoves, state: state)

        #expect(bestMove == .choose(.missed, player: "p1"))
    }
}
