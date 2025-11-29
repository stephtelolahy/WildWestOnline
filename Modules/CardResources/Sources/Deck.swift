//
//  Deck.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 24/11/2024.
//

public enum Deck {
    public static let all: [String: [String]] = bang.merging(dodgeCity) { left, right in left + right }

    static let bang: [String: [String]] = [
        .barrel: ["Q♠️", "K♠️"],
        .dynamite: ["2♥️"],
        .jail: ["J♠️", "10♠️", "4♥️"],
        .schofield: ["K♠️", "J♣️", "Q♣️"],
        .remington: ["K♣️"],
        .revCarabine: ["A♣️"],
        .winchester: ["8♠️"],
        .volcanic: ["10♠️", "10♣️"],
        .scope: ["A♠️"],
        .mustang: ["8♥️", "9♥️"],
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
        .stagecoach: ["8♠️", "9♠️"],
        .wellsFargo: ["3♥️"]
    ]

    static let dodgeCity: [String: [String]] = [
        .bang: ["8♠️", "5♣️", "6♣️", "K♣️"],
        .beer: ["6♥️", "6♠️"],
        .indians: ["5♦️"],
        .punch: ["10♠️"],
        .dodge: ["7♦️", "K♥️"],
//        .springfield: ["K♠️"],
        .hideout: ["K♦️"],
        .generalStore: ["A♠️"],
        .catBalou: ["8♣️"],
        .panic: ["J♥️"],
        .missed: ["8♦️"],
        .remington: ["6♦️"],
        .binocular: ["10♦️"],
        .revCarabine: ["5♠️"],
        .dynamite: ["10♣️"],
        .mustang: ["5♥️"],
        .barrel: ["A♣️"],
//        .whisky: ["Q♦️"],
//        .tequila: ["9♣️"],
//        .ragTime: ["9♥️"],
//        .brawl: ["J♠️"]
    ]
}
