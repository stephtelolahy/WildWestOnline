//
//  Cards.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

import CardGameCore

/// Card scripting database
public enum Cards {
    
    /// complete card script
    /// set name as default id
    public static func get(_ name: String) -> Card {
        guard var card = UniqueCards.all.first(where: { $0.name == name }) else {
            fatalError(.missingCardScript(name))
        }
        
        var parent: String? = card.prototype
        while parent != nil {
            let parentCard = UniqueCards.all.first { $0.name == parent }.unsafelyUnwrapped
            card.canPlay = parentCard.canPlay + card.canPlay
            card.onPlay = parentCard.onPlay + card.onPlay
            parent = parentCard.prototype
        }
        
        card.id = name
        return card
    }
    
    /// all cards of given type
    public static func getAll(type: CardType) -> [Card] {
        UniqueCards.all.filter { $0.type == type }.map { get($0.name) }
    }
    
    /// build random deck with all stored cards
    public static func getDeck() -> [Card] {
        let cardSets = CardSets.all
        let uniqueCards = UniqueCards.all
        var cards: [Card] = []
        for (key, values) in cardSets {
            if let card = uniqueCards.first(where: { $0.name == key }) {
                for value in values {
                    var copy = card
                    copy.value = value
                    copy.id = "\(key)-\(value)"
                    cards.append(copy)
                }
            }
        }
        return cards
    }
}

private enum UniqueCards {
    
    static let all: [Card] = [
        
        Card(name: "playableTurn",
             canPlay: [IsPhase(phase: 2)]),
        
        Card(name: "startTurn",
             type: .inner,
             canPlay: [IsPhase(phase: 1)],
             onPlay: [
                Draw(times: "2"),
                SetPhase(value: 2)
             ]),
        
        Card(name: "endTurn",
             type: .inner,
             prototype: "playableTurn",
             onPlay: [
                Discard(card: .CARD_SELECT_HAND, times: .NUM_EXCESS_HAND),
                SetTurn(player: .PLAYER_NEXT),
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
             onPlay: [ForceDiscard(card: "missed", player: .PLAYER_SELECT_REACHABLE, otherwise: [Damage(value: 1, player: .PLAYER_TARGET)])]),
        
        Card(name: "missed",
             type: .collectible),
        
        Card(name: "gatling",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [ForceDiscard(card: "missed", player: .PLAYER_OTHERS, otherwise: [Damage(value: 1, player: .PLAYER_TARGET)])]),
        
        Card(name: "saloon",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Heal(value: 1, player: .PLAYER_DAMAGED)]),
        
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
             onPlay: [Discard(card: .CARD_SELECT_ANY, player: .PLAYER_SELECT_ANY)]),
        
        Card(name: "panic",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [Steal(player: .PLAYER_ACTOR, card: .CARD_SELECT_ANY, target: .PLAYER_SELECT_AT_1)]),
        
        Card(name: "generalStore",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [
                DeckToStore(times: .NUM_PLAYERS),
                DrawStore(card: .CARD_SELECT_ANY, player: .PLAYER_ALL)
             ]),
        
        Card(name: "indians",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [ForceDiscard(card: "bang", player: .PLAYER_OTHERS, otherwise: [Damage(value: 1, player: .PLAYER_TARGET)])]),
        
        Card(name: "duel",
             type: .collectible,
             prototype: "playableTurn",
             onPlay: [ForceDiscard(card: "bang", player: .PLAYER_SELECT_ANY, otherwise: [Damage(value: 1, player: .PLAYER_TARGET)], challenger: .PLAYER_ACTOR)])
    ]
}

private enum CardSets {
    
    static let all: [String: [String]] = [
        "barrel": ["Q♠️", "K♠️"],
        "dynamite": ["2♥️"],
        "jail": ["J♠️", "10♠️", "4♥️"],
        "mustang": ["8♥️", "9♥️"],
        "remington": ["K♣️"],
        "revCarabine": ["A♣️"],
        "schofield": ["K♠️", "J♣️", "Q♣️"],
        "scope": ["A♠️"],
        "volcanic": ["10♠️", "10♣️"],
        "winchester": ["8♠️"],
        "bang": ["A♠️", "2♦️", "3♦️", "4♦️", "5♦️", "6♦️", "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♦️", "2♣️", "3♣️", "4♣️", "5♣️", "6♣️", "7♣️", "8♣️", "9♣️", "Q♥️", "K♥️", "A♥️"],
        "missed": ["10♣️", "J♣️", "Q♣️", "K♣️", "A♣️", "2♠️", "3♠️", "4♠️", "5♠️", "6♠️", "7♠️", "8♠️"],
        "beer": ["6♥️", "7♥️", "8♥️", "9♥️", "10♥️", "J♥️"],
        "catBalou": ["K♥️", "9♦️", "10♦️", "J♦️"],
        "duel": ["Q♦️", "J♠️", "8♣️"],
        "gatling": ["10♥️"],
        "generalstore": ["9♣️", "Q♠️"],
        "indians": ["K♦️", "A♦️"],
        "panic": ["J♥️", "Q♥️", "A♥️", "8♦️"],
        "saloon": ["5♥️"],
        "stagecoach": ["9♠️", "9♠️"],
        "wellsFargo": ["3♥️"]
    ]
}
