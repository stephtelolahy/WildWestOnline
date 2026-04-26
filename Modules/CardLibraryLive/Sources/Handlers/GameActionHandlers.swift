//
//  GameActionHandlers.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 26/04/2026.
//

import GameCore

public enum GameActionHandlers {
    public static var all: [GameActionHandler.Type] {
        [
            IncrementRequiredMisses.self,
        ]
    }
}
