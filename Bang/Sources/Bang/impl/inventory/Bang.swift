//
//  Bang.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable line_length

/// Bang cards list
enum Bang {
    
    static let uniqueCards: [CardImpl] =
    [
        .init(name: "endTurn",
              type: .ability,
              onPlay: [Repeat(times: NumExcessHand(),
                              effect: Discard(player: PlayerActor(), card: CardSelectHand())),
                       SetTurn(player: PlayerNext())]),
        .init(name: "beer",
              type: .collectible,
              canPlay: [IsPlayersAtLeast(3)],
              onPlay: [Heal(player: PlayerActor(),
                            value: 1)]),
        .init(name: "saloon",
              type: .collectible,
              onPlay: [Heal(player: PlayerDamaged(),
                            value: 1)]),
        .init(name: "stagecoach",
              type: .collectible,
              onPlay: [Repeat(times: NumExact(2),
                              effect: DrawDeck(player: PlayerActor()))]),
        .init(name: "wellsFargo",
              type: .collectible,
              onPlay: [Repeat(times: NumExact(3),
                              effect: DrawDeck(player: PlayerActor()))]),
        .init(name: "generalStore",
              type: .collectible,
              onPlay: [Repeat(times: NumPlayers(),
                              effect: Store()),
                       DrawStore(player: PlayerAll(),
                                 card: CardSelectStore())]),
        // TODO: catBalou permit to discard self's inPlay card, so add new player argument: anyOrSelf
        .init(name: "catBalou",
              type: .collectible,
              onPlay: [Discard(player: PlayerSelectAny(),
                               card: CardSelectAny())]),
        .init(name: "panic",
              type: .collectible,
              onPlay: [Steal(player: PlayerActor(),
                             target: PlayerSelectAt(1),
                             card: CardSelectAny())]),
        .init(name: "bang",
              type: .collectible,
              canPlay: [IsTimesPerTurn(1)],
              onPlay: [ForceDiscard(player: PlayerSelectReachable(),
                                    card: CardSelectHandMatch("missed"),
                                    otherwise: [Damage(player: PlayerCurrent(), value: 1)])]),
        .init(name: "missed",
              type: .collectible),
//        .init(name: "gatling",
//              type: .collectible,
//              onPlay: [.apply(player: .others,
//                              effect: .forceDiscard(player: .current,
//                                                    card: .select(.match("missed")),
//                                                    otherwise: .damage(player: .current, value: 1)))]),
//        .init(name: "indians",
//              type: .collectible,
//              onPlay: [.apply(player: .others,
//                              effect: .forceDiscard(player: .current,
//                                                    card: .select(.match("bang")),
//                                                    otherwise: .damage(player: .current, value: 1)))]),
//        .init(name: "duel",
//              type: .collectible,
//              onPlay: [.challengeDiscard(player: .select(.any),
//                                         card: .select(.any),
//                                         otherwise: .damage(player: .current, value: 1),
//                                         challenger: .actor)])
    ]
    
    static let cardSets: [String: [String]] =
    [
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
