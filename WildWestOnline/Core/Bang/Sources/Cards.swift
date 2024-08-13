//
//  Cards.swift
//
//
//  Created by Hugues Telolahy on 12/08/2024.
//

// swiftlint:disable no_magic_numbers line_length file_length

public enum Cards {
    static let all: [Card] = [
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
        mustang,
        scope,
        jail,
        barrel,
        dynamite,
        willyTheKid,
        roseDoolan,
        paulRegret,
        jourdonnais,
        bartCassidy,
        elGringo,
        suzyLafayette,
        sidKetchum,
        vultureSam,
        slabTheKiller,
        luckyDuke,
        calamityJanet,
        punch,
        dodge,
        springfield,
        hideout,
        binocular,
        whisky,
        tequila,
        ragTime,
        brawl
    ]
}

private extension Cards {
    // MARK: - Default

    static var player: Card {
        .init(
            id: "",
            desc: "",
            attributes: [
                .weapon: 1,
                .flippedCardsOnDraw: 1
            ]
        )
    }

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
            attributes: [.weapon: 2],
            effects: [
                .equip
            ]
        )
    }

    static var remington: Card {
        .init(
            id: "remington",
            desc: "can hit targets at a distance of 3.",
            attributes: [.weapon: 3],
            effects: [
                .equip
            ]
        )
    }

    static var revCarabine: Card {
        .init(
            id: "revCarabine",
            desc: "can hit targets at a distance of 4.",
            attributes: [.weapon: 4],
            effects: [
                .equip
            ]
        )
    }

    static var winchester: Card {
        .init(
            id: "winchester",
            desc: "can hit targets at a distance of 5.",
            attributes: [.weapon: 5],
            effects: [
                .equip
            ]
        )
    }

    static var volcanic: Card {
        .init(
            id: "volcanic",
            desc: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            attributes: [.weapon: 1],
            overrides: ["bang": [.limitPerTurn: 0]],
            effects: [
                .equip
            ]
        )
    }

    static var scope: Card {
        .init(
            id: "scope",
            desc: "you see all the other players at a distance decreased by 1",
            improvements: [.magnifying: 1],
            effects: [
                .equip
            ]
        )
    }

    static var mustang: Card {
        .init(
            id: "mustang",
            desc: "the distance between other players and you is increased by 1",
            improvements: [.remoteness: 1],
            effects: [
                .equip
            ]
        )
    }

    static var jail: Card {
        .init(
            id: "jail",
            desc: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            effects: [
                .handicap,
                .init(
                    when: .turnStarted,
                    action: .draw
                ),
                .init(
                    when: .turnStarted,
                    action: .endTurn,
                    selectors: [
                        .if(.not(.draw("♥️")))
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .discard,
                    selectors: [
                        .card(.played)
                    ]
                )
            ]
        )
    }

    static var barrel: Card {
        .init(
            id: "barrel",
            desc: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            effects: [
                .equip,
                .init(
                    when: .shot,
                    action: .draw
                ),
                .init(
                    when: .shot,
                    action: .missed,
                    selectors: [
                        .if(.draw("♥️"))
                    ]
                )
            ]
        )
    }

    static var dynamite: Card {
        .init(
            id: "dynamite",
            desc: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            effects: [
                .equip,
                .init(
                    when: .turnStarted,
                    action: .draw
                ),
                .init(
                    when: .turnStarted,
                    action: .pass,
                    selectors: [
                        .if(.not(.draw("[2-9]♠️"))),
                        .card(.played),
                        .target(.next)
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .damage,
                    selectors: [
                        .if(.draw("[2-9]♠️")),
                        .arg(.damageAmount, value: .value(3))
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .discard,
                    selectors: [
                        .if(.draw("[2-9]♠️")),
                        .card(.played)
                    ]
                )
            ]
        )
    }

    static var willyTheKid: Card {
        .init(
            id: "willyTheKid",
            desc: "he can play any number of BANG! cards during his turn.",
            attributes: [.maxHealth: 4],
            overrides: ["bang": [.limitPerTurn: 0]]
        )
    }

    static var roseDoolan: Card {
        .init(
            id: "roseDoolan",
            desc: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            attributes: [.maxHealth: 4],
            improvements: [.magnifying: 1]
        )
    }

    static var paulRegret: Card {
        .init(
            id: "paulRegret",
            desc: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            attributes: [.maxHealth: 3],
            improvements: [.remoteness: 1]
        )
    }

    static var jourdonnais: Card {
        .init(
            id: "jourdonnais",
            desc: "he is considered to have a Barrel card in play at all times; he can \"draw!\" when he is the target of a BANG!, and on a Heart he is missed. If he has another real Barrel card in play, he can count both of them, giving him two chances to cancel the BANG! before playing a Missed! card.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .shot,
                    action: .draw
                ),
                .init(
                    when: .shot,
                    action: .missed,
                    selectors: [
                        .if(.draw("♥️"))
                    ]
                )
            ]
        )
    }

    static var bartCassidy: Card {
        .init(
            id: "bartCassidy",
            desc: "each time he loses a life point, he immediately draws a card from the deck.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .damaged,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.lastDamage)
                    ]
                )
            ]
        )
    }

    static var elGringo: Card {
        .init(
            id: "elGringo",
            desc: "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player.",
            attributes: [.maxHealth: 3],
            effects: [
                .init(
                    when: .damaged,
                    action: .steal,
                    selectors: [
                        .target(.offender),
                        .repeat(.lastDamage)
                    ]
                )
            ]
        )
    }

    static var suzyLafayette: Card {
        .init(
            id: "suzyLafayette",
            desc: "as soon as she has no cards in her hand, she draws a card from the draw pile.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .handEmpty,
                    action: .drawDeck
                )
            ]
        )
    }

    static var sidKetchum: Card {
        .init(
            id: "sidKetchum",
            desc: "at any time, he may discard 2 cards from his hand to regain one life point. If he is willing and able, he can use this ability more than once at a time.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .chooseCostHandCard(count: 2)
                    ]
                )
            ]
        )
    }

    static var vultureSam: Card {
        .init(
            id: "vultureSam",
            desc: "whenever a character is eliminated from the game, Sam takes all the cards that player had in his hand and in play, and adds them to his hand.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .otherEliminated,
                    action: .steal,
                    selectors: [
                        .target(.eliminated),
                        .card(.all)
                    ]
                )
            ]
        )
    }

    static var slabTheKiller: Card {
        .init(
            id: "slabTheKiller",
            desc: "players trying to cancel his BANG! cards need to play 2 Missed! cards. The Barrel effect, if successfully used, only counts as one Missed!.",
            attributes: [.maxHealth: 4],
            overrides: ["bang": [.shootRequiredMisses: 2]]
        )
    }

    static var luckyDuke: Card {
        .init(
            id: "luckyDuke",
            desc: "each time he is required to \"draw!\", he flips the top two cards from the deck, and chooses the result he prefers. Discard both cards afterwards.",
            attributes: [
                .maxHealth: 4,
                .flippedCardsOnDraw: 2
            ]
        )
    }

    static var calamityJanet: Card {
        .init(
            id: "calamityJanet",
            desc: "she can use BANG! cards as Missed! cards and vice versa. If she plays a Missed! card as a BANG!, she cannot play another BANG! card that turn (unless she has a Volcanic in play).",
            attributes: [.maxHealth: 4],
            playWith: [
                "missed": "bang",
                "bang": "missed"
            ]
        )
    }

    // MARK: - Dodge city

    static var punch: Card {
        .init(
            id: "punch",
            desc: "Acts as a Bang! with a range of one.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .chooseTarget([.atDistance(.value(1))])
                    ]
                )
            ]
        )
    }

    static var dodge: Card {
        .init(
            id: "dodge",
            desc: "Acts as a Missed!, but allows the player to draw a card.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .missed
                ),
                .init(
                    when: .played,
                    action: .drawDeck
                )
            ]
        )
    }

    static var springfield: Card {
        .init(
            id: "springfield",
            desc: "The player must discard one additional card, and then the card acts as a Bang! with unlimited range.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget()
                    ]
                )
            ]
        )
    }

    static var hideout: Card {
        .init(
            id: "hideout",
            desc: "Others view you at distance +1",
            improvements: [.remoteness: 1]
        )
    }

    static var binocular: Card {
        .init(
            id: "binocular",
            desc: "you view others at distance -1",
            improvements: [.magnifying: 1]
        )
    }

    static var whisky: Card {
        .init(
            id: "whisky",
            desc: "The player must discard one additional card, to heal two health.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .chooseCostHandCard(),
                        .arg(.healAmount, value: .value(2))
                    ]
                )
            ]
        )
    }

    static var tequila: Card {
        .init(
            id: "tequila",
            desc: "The player must discard one additional card, to heal any player one health.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget()
                    ]
                )
            ]
        )
    }

    static var ragTime: Card {
        .init(
            id: "ragTime",
            desc: "The player must discard one additional card to steal a card from any other player.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .steal,
                    selectors: [
                        .chooseCostHandCard(),
                        .chooseTarget(),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var brawl: Card {
        .init(
            id: "brawl",
            desc: "The player must discard one additional card to cause all other players to discard one card.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .discard,
                    selectors: [
                        .chooseCostHandCard(),
                        .target(.all),
                        .chooseCard()
                    ]
                )
            ]
        )
    }
}
