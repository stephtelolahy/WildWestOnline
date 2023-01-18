//
//  Sample.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Bang

enum Sample {
    
    static let game: Game = GameImpl(
        players: ["p1": PlayerImpl(name: "p1"),
                  "p2": PlayerImpl(name: "p2"),
                  "p3": PlayerImpl(name: "p3")]
    )
}
