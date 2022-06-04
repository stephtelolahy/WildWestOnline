//
//  Cards.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//
import CardGameCore

public enum Cards {
    
    private static let all: [Card] = [
        Card(name: "playableTurn",
             canPlay: [IsYourTurn(), IsPhase(phase: 2)]),
        
        Card(name: "playableStart",
             canPlay: [IsYourTurn(), IsPhase(phase: 1)]),
        
        Card(name: "startTurn",
             prototype: "playableStart",
             onPlay: [Draw(value: 2), SetPhase(value: 2)]),
        
        Card(name: "beer",
             prototype: "playableTurn",
             canPlay: [IsPlayersAtLeast(count: 3)],
             onPlay: [Heal(value: 1)]),
        
        Card(name: "bang",
             prototype: "playableTurn",
             canPlay: [IsTimesPerTurn(maxTimes: 1)],
             onPlay: [Damage(value: 1, target: Args.targetReachable, type: Args.effectTypeShoot)]),
        
        Card(name: "missed",
             onPlay: [Silent(type: Args.effectTypeShoot)]),
        
        Card(name: "gatling",
             prototype: "playableTurn",
             onPlay: [Damage(value: 1, target: Args.playerOthers, type: Args.effectTypeShoot)])
    ]
}

public extension Cards {
    
    /// resolving complete card script
    static func get(_ name: String) -> Card {
        var card = all.first { $0.name == name }.unsafelyUnwrapped
        var parent: String? = card.prototype
        while parent != nil {
            let parentCard = all.first { $0.name == parent }.unsafelyUnwrapped
            card.canPlay = parentCard.canPlay + card.canPlay
            card.onPlay = parentCard.onPlay + card.onPlay
            parent = parentCard.prototype
        }
        return card
    }
    
    static let playable: [Card] = ["beer", "bang", "missed"].map { get($0) }
    
    static let inner: [Card] = ["startTurn"].map { get($0) }
}
