//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 12/08/2024.
//

// swiftlint:disable no_magic_numbers line_length

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
/// Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public enum Inventory {
    public struct Card: Equatable, Codable {
        public let id: String
        public let desc: String
        public let effects: [Effect]
    }

    static var cards: [Card] = [
        beer,
        saloon,
        stagecoach,
        wellsFargo,
        catBalou,
        panic,
        bang,
        missed,
        gatling,
        indians,
        duel,
        generalStore,
        schofield,
        remington,
        revCarabine,
        winchester,
        volcanic,
        scope,
        mustang
    ]
}

private extension Inventory {
    // MARK: - Bang

    static var beer: Card {
        .init(
            id: "beer",
            desc: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .if(.playersAtLeast(3))
                    ]
                )
            ]
        )
    }

    static var saloon: Card {
        .init(
            id: "saloon",
            desc: "All players in play regain one life point.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .target(.all)
                    ]
                )
            ]
        )
    }

    static var stagecoach: Card {
        .init(
            id: "stagecoach",
            desc: "Draw two cards from the top of the deck.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var wellsFargo: Card {
        .init(
            id: "wellsFargo",
            desc: "Draw three cards from the top of the deck.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ]
                )
            ]
        )
    }

    static var catBalou: Card {
        .init(
            id: "catBalou",
            desc: "Force “any one player” to “discard a card”, regardless of the distance.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .discard,
                    selectors: [
                        .chooseTarget([.havingCard]),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var panic: Card {
        .init(
            id: "panic",
            desc: "Draw a card from a player at distance 1",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .steal,
                    selectors: [
                        .chooseTarget([.atDistance(.value(1)), .havingCard]),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var bang: Card {
        .init(
            id: "bang",
            desc: "reduce other players’s life points",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .arg(.limitPerTurn, value: .value(1)),
                        .if(.playedLessThan(.arg(.limitPerTurn))),
                        .chooseTarget([.atDistance(.playerAttr(.weapon))]),
                        .arg(.shootRequiredMisses, value: .value(1)),
                        .arg(.damageAmount, value: .value(1))
                    ]
                )
            ]
        )
    }

    static var missed: Card {
        .init(
            id: "missed",
            desc: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .missed
                )
            ]
        )
    }

    static var gatling: Card {
        .init(
            id: "gatling",
            desc: "shoots to all the other players, regardless of the distance",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .target(.others)
                    ]
                )
            ]
        )
    }

    static var indians: Card {
        .init(
            id: "indians",
            desc: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .damage,
                    selectors: [
                        .target(.others),
                        .chooseEventuallyCounterHandCard(.named("bang"))
                    ]
                )
            ]
        )
    }

    static var duel: Card {
        .init(
            id: "duel",
            desc: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .damage,
                    selectors: [
                        .chooseTarget(),
                        .chooseEventuallyReverseHandCard(.named("bang"))
                    ]
                )
            ]
        )
    }

    static var generalStore: Card {
        .init(
            id: "generalStore",
            desc: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .reveal,
                    selectors: [
                        .arg(.revealAmount, value: .activePlayers)
                    ]
                ),
                .init(
                    when: .played,
                    action: .chooseCard,
                    selectors: [
                        .target(.all),
                        .chooseCard(.revealed)
                    ]
                )
            ]
        )
    }

    static var schofield: Card {
        .init(
            id: "schofield",
            desc: "can hit targets at a distance of 2.",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .setAttribute,
                    selectors: [
                        .attr(.weapon, value: 2)
                    ]
                )
            ]
        )
    }

    static var remington: Card {
        .init(
            id: "remington",
            desc: "can hit targets at a distance of 3.",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .setAttribute,
                    selectors: [
                        .attr(.weapon, value: 3)
                    ]
                )
            ]
        )
    }

    static var revCarabine: Card {
        .init(
            id: "revCarabine",
            desc: "can hit targets at a distance of 4.",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .setAttribute,
                    selectors: [
                        .attr(.weapon, value: 4)
                    ]
                )
            ]
        )
    }

    static var winchester: Card {
        .init(
            id: "winchester",
            desc: "can hit targets at a distance of 5.",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .setAttribute,
                    selectors: [
                        .attr(.weapon, value: 5)
                    ]
                )
            ]
        )
    }

    static var volcanic: Card {
        .init(
            id: "volcanic",
            desc: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .overrideArg,
                    selectors: [
                        .overrideArg(.limitPerTurn, value: 0, card: "bang")
                    ]
                ),
                .init(
                    when: .played,
                    action: .setAttribute,
                    selectors: [
                        .attr(.weapon, value: 1)
                    ]
                )
            ]
        )
    }

    static var scope: Card {
        .init(
            id: "scope",
            desc: "you see all the other players at a distance decreased by 1",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .incrementAttribute,
                    selectors: [
                        .attr(.magnifying, value: 1)
                    ]
                )
            ]
        )
    }

    static var mustang: Card {
        .init(
            id: "mustang",
            desc: "the distance between other players and you is increased by 1",
            effects: [
                .equip,
                .init(
                    when: .played,
                    action: .incrementAttribute,
                    selectors: [
                        .attr(.remoteness, value: 1)
                    ]
                )
            ]
        )
    }
}
