//
//  Cards.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//
import CardGameCore

public enum Cards {
    
    public static let all: [Card] = [
        Card(name: "beer",
             canPlay: [IsPlayersAtLeast(count: 3)],
             onPlay: [Heal(value: 1)]),
        Card(name: "bang",
             canPlay: [IsTimesPerTurn(maxTimes: 1)],
             onPlay: [Damage(value: 1, target: Args.targetReachable, type: Args.effectTypeShoot)]),
        Card(name: "missed",
             onPlay: [Silent(type: Args.effectTypeShoot)])
    ]
}

public extension Cards {
    
    static func get(_ name: String) -> Card {
        all.first { $0.name == name }.unsafelyUnwrapped
    }
}
