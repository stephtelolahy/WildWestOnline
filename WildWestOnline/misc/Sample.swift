//
//  Sample.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Bang

enum Sample {
    
    static let game: Game = GameImpl(
        players: ["p1": PlayerImpl(name: "willyTheKid"),
                  "p2": PlayerImpl(name: "blackJack"),
                  "p3": PlayerImpl(name: "pedroRamirez")],
        playOrder: ["p1", "p2", "p3"]
    )
}
