//
//  Sample.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameCore

enum Sample {
    
    static let game: Game = GameImpl(
        players: [.willyTheKid: PlayerImpl(id: .willyTheKid, name: .willyTheKid),
                  .blackJack: PlayerImpl(id: .blackJack, name: .blackJack),
                  .pedroRamirez: PlayerImpl(id: .pedroRamirez, name: .pedroRamirez)],
        playOrder: [.willyTheKid, .pedroRamirez, .blackJack]
    )
}
