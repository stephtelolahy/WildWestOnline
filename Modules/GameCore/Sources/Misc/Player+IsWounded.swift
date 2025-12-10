//
//  Player+IsWounded.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/11/2025.
//

extension GameFeature.State.Player {
    var isWounded: Bool {
        health < maxHealth
    }
}
