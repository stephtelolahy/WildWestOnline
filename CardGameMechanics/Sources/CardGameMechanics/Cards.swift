//
//  Cards.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//
// swiftlint:disable line_length

import CardGameCore

public enum Cards {
    
    /// resolving complete card script
    public static func get(_ name: String) -> Card {
        guard var card = all.first(where: { $0.name == name }) else {
            fatalError(.cardScriptNotFound(name))
        }
        
        var parent: String? = card.prototype
        while parent != nil {
            let parentCard = all.first { $0.name == parent }.unsafelyUnwrapped
            card.canPlay = parentCard.canPlay + card.canPlay
            card.onPlay = parentCard.onPlay + card.onPlay
            parent = parentCard.prototype
        }
        return card
    }
    
    /// all cards of given type
    public static func getAll(type: CardType) -> [Card] {
        all.filter { $0.type == type }.map { get($0.name) }
    }
}

private extension Cards {
    
    /// cards database
    static let all: [Card] = [
        
        Card(name: "playableTurn",
             canPlay: [IsYourTurn(), IsPhase(phase: 2)]),
        
        Card(name: "playableStart",
             canPlay: [IsYourTurn(), IsPhase(phase: 1)]),
        
        Card(name: "startTurn",
             type: .inner,
             prototype: "playableStart",
             onPlay: [
                Draw(times: "2"),
                SetPhase(value: 2)
             ]),
        
        Card(name: "endTurn",
             type: .inner,
             prototype: "playableTurn",
             onPlay: [
                Discard(card: Args.cardSelectHand, times: Args.numExcessHand),
                SetTurn(player: Args.playerNext),
                SetPhase(value: 1)
             ]),
        
        Card(name: "beer",
             type: .collectible,
             prototype: "playableTurn",
             canPlay: [IsPlayersAtLeast(count: 3)],
             onPlay: [Heal(value: 1)]),
        
        Card(name: "bang",
             type: .collectible,
             prototype: "playableTurn",
             canPlay: [IsTimesPerTurn(maxTimes: 1)],
             onPlay: [Damage(value: 1, target: Args.playerSelectReachable, type: Args.effectTypeShoot)]),
        
        Card(name: "missed",
             type: .collectible,
             onPlay: [Silent(type: Args.effectTypeShoot)]),
        
        Card(name: "gatling",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Damage(value: 1, target: Args.playerOthers, type: Args.effectTypeShoot)]),
        
        Card(name: "saloon",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Heal(value: 1, target: Args.playerAll)]),
        
        Card(name: "stagecoach",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Draw(times: "2")]),
        
        Card(name: "wellsFargo",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Draw(times: "3")]),
        
        Card(name: "catBalou",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Discard(card: Args.cardSelectAny, target: Args.playerSelectAny)]),
        
        Card(name: "panic",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Steal(card: Args.cardSelectAny, target: Args.playerSelectAt1)]),
        
        Card(name: "generalStore",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [
                DeckToStore(times: Args.numPlayers),
                DrawStore(card: Args.cardSelectAny, target: Args.playerAll)
             ]),
        
        Card(name: "indians",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [ForceDiscard(card: "bang", target: Args.playerOthers, otherwise: [Damage(value: 1, target: Args.playerTarget)])]),
        
        Card(name: "duel",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [ForceDiscard(card: "bang", target: Args.playerSelectAny, challenger: Args.playerActor, otherwise: [Damage(value: 1, target: Args.playerTarget)])])
    ]
}
