//
//  GameDefault.swift
//
//
//  Created by Hugues Telolahy on 14/07/2023.
//
import Game

public enum GameDefault {
    public static let abilities: [String] = [
        .endTurn,
        .drawOnSetTurn,
        .eliminateOnLooseLastHealth,
        .evaluateGameOverOnEliminated,
        .discardCardsOnEliminated,
        .nextTurnOnEliminated,
        .discardPreviousWeaponOnPlayWeapon
    ]

    public static let attributes: Attributes = [
        .startTurnCards: 2,
        .weapon: 1,
        .flippedCards: 1,
        .bangsPerTurn: 1
    ]
}
