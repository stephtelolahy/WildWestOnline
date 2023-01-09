//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

enum Inventory {
    
    static let uniqueCards: [CardImpl] = [
        // start turn should be a triggered effect
//        .init(name: "startTurn",
//              type: .inner,
//              onPlay: [.loop(times: "2", effect: .draw(player: .PLAYER_ACTOR)),
//                       .setPhase(value: 2)]),
        .init(name: "endTurn",
              type: .inner,
              onPlay: [.loop(times: .NUM_EXCESS_HAND, effect: .discard(player: .PLAYER_ACTOR, card: .CARD_SELECT_HAND)),
                       .setTurn(player: .PLAYER_NEXT),
                       .setPhase(value: 1)]),
        .init(name: "beer",
              type: .collectible,
              onPlay: [.heal(player: .PLAYER_ACTOR, value: 1)]),
        .init(name: "bang",
              type: .collectible,
              onPlay: [.forceDiscard(player: .PLAYER_ACTOR, card: "missed", otherwise: .damage(player: .PLAYER_ACTOR, value: 1))]),
        .init(name: "missed",
              type: .collectible),
        .init(name: "gatling",
              type: .collectible,
              onPlay: [.apply(players: .PLAYER_OTHERS, effect: .forceDiscard(player: .PLAYER_TARGET, card: "missed", otherwise: .damage(player: .PLAYER_TARGET, value: 1)))]),
        .init(name: "saloon",
              type: .collectible,
              onPlay: [.apply(players: .PLAYER_ALL, effect: .heal(player: .PLAYER_TARGET, value: 1))]),
        .init(name: "stagecoach",
              type: .collectible,
              onPlay: [.loop(times: "2", effect: .draw(player: .PLAYER_ACTOR))]),
        .init(name: "wellsFargo",
              type: .collectible,
              onPlay: [.loop(times: "3", effect: .draw(player: .PLAYER_ACTOR))]),
        .init(name: "catBalou",
              type: .collectible,
              onPlay: [.discard(player: .PLAYER_SELECT_ANY, card: .CARD_SELECT_ANY)]),
        .init(name: "panic",
              type: .collectible,
              onPlay: [.steal(player: .PLAYER_ACTOR, target: .PLAYER_SELECT_AT_1, card: .CARD_SELECT_ANY)]),
        .init(name: "generalStore",
              type: .collectible,
              onPlay: [.loop(times: .NUM_PLAYERS, effect: .store),
                       .apply(players: .PLAYER_ALL, effect: .choose(player: .PLAYER_TARGET, card: .CARD_SELECT_ANY))]),
        .init(name: "indians",
              type: .collectible,
              onPlay: [.apply(players: .PLAYER_OTHERS, effect: .forceDiscard(player: .PLAYER_TARGET, card: "bang", otherwise: .damage(player: .PLAYER_TARGET, value: 1)))]),
        .init(name: "duel",
              type: .collectible,
              onPlay: [.challengeDiscard(player: .PLAYER_SELECT_ANY, card: .CARD_SELECT_ANY, challenger: .PLAYER_ACTOR, otherwise: .damage(player: .PLAYER_TARGET, value: 1))])
    ]
    
    static let cardSets: [String: [String]] = [
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


