//
//  InventoryImpl.swift
//
//
//  Created by Hugues Telolahy on 09/01/2023.
//
// swiftlint:disable: line_length

public struct InventoryImpl: Inventory {
    
    public init() {}
    
    public func getCard(_ name: String, withId id: String?) -> Card {
        guard var card = Self.uniqueCards.first(where: { $0.name == name }) else {
            fatalError("undefined card \(name)")
        }
        
        card.id = id ?? name
        return card
    }
}

private extension InventoryImpl {
    
    static let uniqueCards: [CardImpl] =
    [
        .init(name: "endTurn",
              type: .defaultAbility,
              onPlay: [.loop(times: .numExcessHand,
                             effect: .discard(player: .actor, card: .select(.hand))),
                       .setTurn(player: .next)]),
        .init(name: "beer",
              type: .collectible,
              canPlay: [.isPlayersAtLeast(3)],
              onPlay: [.heal(player: .actor,
                             value: 1)]),
        .init(name: "bang",
              type: .collectible,
              canPlay: [.isTimesPerTurn(1)],
              onPlay: [.forceDiscard(player: .actor,
                                     card: .select(.match("missed")),
                                     otherwise: .damage(player: .actor, value: 1))]),
        .init(name: "missed",
              type: .collectible),
        .init(name: "gatling",
              type: .collectible,
              onPlay: [.apply(player: .others,
                              effect: .forceDiscard(player: .current,
                                                    card: .select(.match("missed")),
                                                    otherwise: .damage(player: .current, value: 1)))]),
        .init(name: "saloon",
              type: .collectible,
              onPlay: [.apply(player: .damaged,
                              effect: .heal(player: .current, value: 1))]),
        .init(name: "stagecoach",
              type: .collectible,
              onPlay: [.loop(times: .exact(2),
                             effect: .draw(player: .actor))]),
        .init(name: "wellsFargo",
              type: .collectible,
              onPlay: [.loop(times: .exact(3),
                             effect: .draw(player: .actor))]),
        .init(name: "catBalou",
              type: .collectible,
              onPlay: [.discard(player: .select(.any),
                                card: .select(.any))]),
        .init(name: "panic",
              type: .collectible,
              onPlay: [.steal(player: .actor,
                              target: .select(.at(1)),
                              card: .select(.any))]),
        .init(name: "generalStore",
              type: .collectible,
              onPlay: [.loop(times: .numPlayers,
                             effect: .store),
                       .apply(player: .all,
                              effect: .choose(player: .current,
                                              card: .select(.store)))]),
        .init(name: "indians",
              type: .collectible,
              onPlay: [.apply(player: .others,
                              effect: .forceDiscard(player: .current,
                                                    card: .select(.match("bang")),
                                                    otherwise: .damage(player: .current, value: 1)))]),
        .init(name: "duel",
              type: .collectible,
              onPlay: [.challengeDiscard(player: .select(.any),
                                         card: .select(.any),
                                         otherwise: .damage(player: .current, value: 1),
                                         challenger: .actor)])
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
