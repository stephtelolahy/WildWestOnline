//
//  QueueModifiers.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/11/2025.
//
import GameFeature

public enum QueueModifiers {
    public static var allHandlers: [QueueModifierHandler.Type] {
        [
            IncrementCardsPerTurn.self,
            IncrementRequiredMisses.self,
            IgnoreLimitPerTurn.self,
        ]
    }
}
