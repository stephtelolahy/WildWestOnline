//
//  CardList.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable line_length

/// Bang cards list
enum CardList {
    
    static let abilities: [CardImpl] = [
        .init(name: .endTurn,
              onPlay: [Repeat(times: NumExcessHand(),
                              effect: Discard(player: PlayerActor(), card: CardSelectHand())),
                       SetTurn(player: PlayerNext())]),
        .init(name: .startTurn,
              triggers: [OnSetTurn()],
              onTrigger: [Repeat(times: NumExact(2),
                                 effect: DrawDeck(player: PlayerActor()))]),
        .init(name: .leaveGame,
              triggers: [OnLooseLastHealth()],
              onTrigger: [Eliminate(player: PlayerActor())]),
        .init(name: .gameOver,
              triggers: [OnEliminated()],
              onTrigger: [EndGame()])
    ]
    
    static let collectibleCards: [CardImpl] = [
        .init(name: .beer,
              canPlay: [IsPlayersAtLeast(3)],
              onPlay: [Heal(player: PlayerActor(),
                            value: 1)]),
        .init(name: .saloon,
              onPlay: [Heal(player: PlayerDamaged(),
                            value: 1)]),
        .init(name: .stagecoach,
              onPlay: [Repeat(times: NumExact(2),
                              effect: DrawDeck(player: PlayerActor()))]),
        .init(name: .wellsFargo,
              onPlay: [Repeat(times: NumExact(3),
                              effect: DrawDeck(player: PlayerActor()))]),
        .init(name: .generalStore,
              onPlay: [Repeat(times: NumPlayers(),
                              effect: Store()),
                       DrawStore(player: PlayerAll(),
                                 card: CardSelectStore())]),
        // TODO: catBalou may discard self's inPlay card, so add new player argument: anyOrSelf
        .init(name: .catBalou,
              playTarget: PlayerSelectAny(),
              onPlay: [Discard(player: PlayerTarget(),
                               card: CardSelectAny())]),
        .init(name: .panic,
              playTarget: PlayerSelectAt(1),
              onPlay: [Steal(player: PlayerActor(),
                             target: PlayerTarget(),
                             card: CardSelectAny())]),
        .init(name: .bang,
              playTarget: PlayerSelectReachable(),
              canPlay: [IsTimesPerTurn(1)],
              onPlay: [ForceDiscard(player: PlayerTarget(),
                                    card: CardSelectHandNamed(.missed),
                                    otherwise: [Damage(player: PlayerTarget(), value: 1)])]),
        .init(name: .missed),
        .init(name: .gatling,
              onPlay: [ForceDiscard(player: PlayerOthers(),
                                    card: CardSelectHandNamed(.missed),
                                    otherwise: [Damage(player: PlayerTarget(), value: 1)])]),
        .init(name: .indians,
              onPlay: [ForceDiscard(player: PlayerOthers(),
                                    card: CardSelectHandNamed(.bang),
                                    otherwise: [Damage(player: PlayerTarget(), value: 1)])]),
        .init(name: .duel,
              playTarget: PlayerSelectAny(),
              onPlay: [ChallengeDiscard(player: PlayerTarget(),
                                        challenger: PlayerActor(),
                                        card: CardSelectHandNamed(.bang),
                                        otherwise: [Damage(player: PlayerTarget(), value: 1)])])
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
        .bang: ["A♠️", "2♦️", "3♦️", "4♦️", "5♦️", "6♦️", "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️", "K♦️", "A♦️", "2♣️", "3♣️", "4♣️", "5♣️", "6♣️", "7♣️", "8♣️", "9♣️", "Q♥️", "K♥️", "A♥️"],
        .missed: ["10♣️", "J♣️", "Q♣️", "K♣️", "A♣️", "2♠️", "3♠️", "4♠️", "5♠️", "6♠️", "7♠️", "8♠️"],
        .beer: ["6♥️", "7♥️", "8♥️", "9♥️", "10♥️", "J♥️"],
        .catBalou: ["K♥️", "9♦️", "10♦️", "J♦️"],
        .duel: ["Q♦️", "J♠️", "8♣️"],
        .gatling: ["10♥️"],
        .generalStore: ["9♣️", "Q♠️"],
        .indians: ["K♦️", "A♦️"],
        .panic: ["J♥️", "Q♥️", "A♥️", "8♦️"],
        .saloon: ["5♥️"],
        .stagecoach: ["9♠️", "9♠️"],
        .wellsFargo: ["3♥️"]
    ]
}