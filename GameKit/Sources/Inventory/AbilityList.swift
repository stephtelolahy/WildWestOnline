//
//  AbilityList.swift
//  
//
//  Created by Hugues Telolahy on 14/07/2023.
//

public enum AbilityList {
    public static let `default`: [String] = [
        .endTurn,
        .drawOnSetTurn,
        .eliminateOnLooseLastHealth,
        .gameOverOnEliminated,
        .discardCardsOnEliminated,
        .nextTurnOnEliminated
    ]
}
