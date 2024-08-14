//
//  Cards.swift
//
//
//  Created by Hugues Telolahy on 12/08/2024.
//

// swiftlint:disable no_magic_numbers line_length file_length

public enum Cards {
    static let all: [Card] = [
        defaultDraw2CardsOnTurnStarted,
        defaultDiscardExcessHandOnTurnEnded,
        defaultStartTurnNextOnTurnEnded,
        defaultEliminateOnDamageLethal,
        defaultDiscardAllCardsOnEliminated,
        defaultEndTurnOnEliminated,
        defaultDiscardPreviousWeaponOnPlayed,
        defaultDiscardBeerOnDamagedLethal,

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
        kitCarlson,
        blackJack,
        jesseJones,
        pedroRamirez,

        punch,
        dodge,
        springfield,
        hideout,
        binocular,
        whisky,
        tequila,
        ragTime,
        brawl,
        elenaFuente,
        seanMallory,
        tequilaJoe,
        pixiePete,
        billNoface,
        gregDigger,
        herbHunter,
        mollyStark,
        joseDelgado,
        chuckWengam,
        docHolyday,
        apacheKid,
        belleStar,
        patBrennan,
        veraCuster,

        lastCall,
        tornado,
        backfire,
        tomahawk,
        aim,
        faning,
        saved,
        bandidos,
        poker,
        lemat,
        shootgun,
        bounty,
        rattlesnake,
        escape,
        ghost,
        coloradoBill,
        evelynShebang,
        lemonadeJim,
        henryBlock,
        blackFlower,
        derSpotBurstRinger,
        tucoFranziskaner
    ]
}

private extension Cards {
    // MARK: - Default

    static var defaultAttributes: [PlayerAttribute: Int] {
        [
            .weapon: 1,
            .drawCards: 1
        ]
    }

    static var defaultDraw2CardsOnTurnStarted: Card {
        .init(
            id: "defaultDraw2CardsOnTurnStarted",
            desc: "Draw two cards at the beginning of your turn",
            effects: [
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .arg(.repeatAmount, value: .value(2)),
                        .repeat(.arg(.repeatAmount))
                    ]
                )
            ]
        )
    }

    static var defaultDiscardExcessHandOnTurnEnded: Card {
        .init(
            id: "defaultDiscardExcessHandOnTurnEnded",
            desc: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            effects: [
                .init(
                    when: .played,
                    action: .discard,
                    selectors: [
                        .repeat(.excessHand),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var defaultEliminateOnDamageLethal: Card {
        .init(
            id: "defaultEliminateOnDamageLethal",
            desc: "When you lose your last life point, you are eliminated and your game is over",
            effects: [
                .init(
                    when: .damagedLethal,
                    action: .eliminate
                )
            ]
        )
    }

    static var defaultDiscardAllCardsOnEliminated: Card {
        .init(
            id: "defaultDiscardAllCardsOnEliminated",
            desc: "",
            effects: [
                .init(
                    when: .eliminated,
                    action: .discard,
                    selectors: [
                        .card(.all)
                    ]
                )
            ]
        )
    }

    static var defaultEndTurnOnEliminated: Card {
        .init(
            id: "defaultEndTurnOnEliminated",
            desc: "",
            effects: [
                .init(
                    when: .eliminated,
                    action: .endTurn,
                    selectors: [
                        .if(.actorTurn)
                    ]
                )
            ]
        )
    }

    static var defaultStartTurnNextOnTurnEnded: Card {
        .init(
            id: "defaultStartTurnNextOnTurnEnded",
            desc: "",
            effects: [
                .init(
                    when: .turnEnded,
                    action: .startTurn,
                    selectors: [
                        .target(.next)
                    ]
                )
            ]
        )
    }

    static var defaultDiscardPreviousWeaponOnPlayed: Card {
        .init(
            id: "defaultDiscardPreviousWeaponOnPlayed",
            desc: "",
            effects: [
                .init(
                    when: .cardPlayedWithAttr(.weapon),
                    action: .discard,
                    selectors: [
                        .card(.inPlayWithAttr(.weapon))
                    ]
                )
            ]
        )
    }

    static var defaultDiscardBeerOnDamagedLethal: Card {
        .init(
            id: "defaultDiscardBeerOnDamagedLethal",
            desc: "When you lose your last life point, you are eliminated and your game is over, unless you immediately play a Beer",
            canPlay: .damagedLethal,
            effects: [
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .if(.playersAtLeast(3)),
                        .chooseCostHandCard(.named("beer"))
                    ]
                )
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
                        .chooseTarget([.atDistance(1), .havingCard]),
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
                        .chooseTarget([.atDistanceReachable]),
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
            canPlay: .shot,
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
                    action: .drawDeck,
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
                    action: .handicap,
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
                .drawCards: 2
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

    static var kitCarlson: Card {
        .init(
            id: "kitCarlson",
            desc: "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down.",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 0]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .reveal,
                    selectors: [
                        .arg(.revealAmount, value: .value(3))
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ]
                )
            ]
        )
    }

    static var blackJack: Card {
        .init(
            id: "blackJack",
            desc: "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it).",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 0]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .arg(.repeatAmount, value: .value(2)),
                        .repeat(.arg(.repeatAmount))
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .showLastDraw
                ),
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .if(.draw("(♥️)|(♦️)"))
                    ]
                )
            ]
        )
    }

    static var jesseJones: Card {
        // ⚠️ TODO: choose to override default effect
        .init(
            id: "jesseJones",
            desc: "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck.",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 0]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .drawDiscard
                ),
                .init(
                    when: .turnStarted,
                    action: .drawDeck
                )
            ]
        )
    }

    static var pedroRamirez: Card {
        // ⚠️ TODO: choose to override default effect
        .init(
            id: "pedroRamirez",
            desc: "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck.",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 0]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .steal,
                    selectors: [
                        .chooseTarget([.havingHandCard]),
                        .chooseCard()
                    ]
                ),
                .init(
                    when: .turnStarted,
                    action: .drawDeck
                )
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
                        .chooseTarget([.atDistance(1)])
                    ]
                )
            ]
        )
    }

    static var dodge: Card {
        .init(
            id: "dodge",
            desc: "Acts as a Missed!, but allows the player to draw a card.",
            canPlay: .shot,
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
            attributes: [.maxHealth: 4],
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

    static var elenaFuente: Card {
        .init(
            id: "elenaFuente",
            desc: "She may use any card in hand as Missed!.",
            attributes: [.maxHealth: 3],
            playWith: ["missed": ""]
        )
    }

    static var seanMallory: Card {
        .init(
            id: "seanMallory",
            desc: "He may hold in his hand up to 10 cards.",
            attributes: [
                .handLimit: 10,
                .maxHealth: 3
            ]
        )
    }

    static var tequilaJoe: Card {
        .init(
            id: "tequilaJoe",
            desc: "Each time he plays a Beer, he regains 2 life points instead of 1.",
            attributes: [.maxHealth: 4],
            overrides: ["beer": [.healAmount: 2]]
        )
    }

    static var pixiePete: Card {
        .init(
            id: "pixiePete",
            desc: "During phase 1 of his turn, he draws 3 cards instead of 2.",
            attributes: [.maxHealth: 3],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 3]]
        )
    }

    static var billNoface: Card {
        .init(
            id: "billNoface",
            desc: "He draws 1 card, plus 1 card for each wound he has.",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 1]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.damage)
                    ]
                )
            ]
        )
    }

    static var gregDigger: Card {
        .init(
            id: "gregDigger",
            desc: "Each time another player is eliminated, he regains 2 life points.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .otherEliminated,
                    action: .heal,
                    selectors: [
                        .arg(.healAmount, value: .value(2))
                    ]
                )
            ]
        )
    }

    static var herbHunter: Card {
        .init(
            id: "herbHunter",
            desc: "Each time another player is eliminated, he draws 2 extra cards.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .otherEliminated,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var mollyStark: Card {
        .init(
            id: "mollyStark",
            desc: "Each time she uses a card from her hand out of turn, she draw a card.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .playedCardOutOfTurn,
                    action: .drawDeck,
                    selectors: [
                        .if(.playedLessThan(.value(2)))
                    ]
                )
            ]
        )
    }

    static var joseDelgado: Card {
        .init(
            id: "joseDelgado",
            desc: "Twice in his turn, he may discard a blue card from the hand to draw 2 cards.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .if(.playedLessThan(.value(2))),
                        .chooseCostHandCard(.isBlue),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var chuckWengam: Card {
        .init(
            id: "chuckWengam",
            desc: "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .chooseEventuallyCostLifePoint,
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var docHolyday: Card {
        .init(
            id: "docHolyday",
            desc: "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!.",
            attributes: [.maxHealth: 4],
            effects: [
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .if(.playedLessThan(.value(1))),
                        .chooseCostHandCard(count: 2),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var apacheKid: Card {
        .init(
            id: "apacheKid",
            desc: "Cards of Diamond played by other players do not affect him",
            attributes: [
                .silentCardsDiamonds: 0,
                .maxHealth: 3
            ]
        )
    }

    static var belleStar: Card {
        .init(
            id: "belleStar",
            desc: "During her turn, cards in play in front of other players have no effect. ",
            attributes: [
                .silentCardsInPlayDuringTurn: 0,
                .maxHealth: 4
            ]
        )
    }

    static var patBrennan: Card {
        // ⚠️ TODO: choose to override default effect
        .init(
            id: "patBrennan",
            desc: "Instead of drawing normally, he may draw only one card in play in front of any one player.",
            attributes: [.maxHealth: 4],
            overrides: ["defaultDraw2CardsOnTurnStarted": [.repeatAmount: 0]],
            effects: [
                .init(
                    when: .turnStarted,
                    action: .steal,
                    selectors: [
                        .chooseTarget([.havingInPlayCard]),
                        .chooseCard(.inPlay)
                    ]
                )
            ]
        )
    }

    static var veraCuster: Card {
        // ⚠️ TODO: set abilities for a round
        .init(
            id: "veraCuster",
            desc: "For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn",
            attributes: [.maxHealth: 3]
        )
    }

    // MARK: - The Valley of Shadows

    static var lastCall: Card {
        .init(
            id: "lastCall",
            desc: "Refill 1 life point even in game last 2 players.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal
                )
            ]
        )
    }

    static var tornado: Card {
        .init(
            id: "tornado",
            desc: "Each player discards a card from their hand (if possible), then draw 2 cards from the deck",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .target(.all),
                        .chooseCostHandCard(),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var backfire: Card {
        .init(
            id: "backfire",
            desc: "Count as MISSED!. Player who shot you, is now target of BANG!.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .missed
                ),
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .target(.offender)
                    ]
                )
            ]
        )
    }

    static var tomahawk: Card {
        .init(
            id: "tomahawk",
            desc: "Bang at distance 2. But it can be used at distance 1",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .chooseTarget([.atDistance(2)])
                    ]
                )
            ]
        )
    }

    static var aim: Card {
        .init(
            id: "aim",
            desc: "Play with Bang card. If defending player doesn't miss, he loses 2 life points instead",
            overrides: ["bang": [.damageAmount: 2]],
            canPlay: .cardPlayedWithName("bang"),
            effects: [
                .brown
            ]
        )
    }

    static var faning: Card {
        // ⚠️ TODO: play this as another card
        .init(
            id: "faning",
            desc: "Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .arg(.limitPerTurn, value: .value(1)),
                        .if(.playedLessThan(.arg(.limitPerTurn))),
                        .chooseTarget([.atDistanceReachable]),
                        .arg(.shootRequiredMisses, value: .value(1)),
                        .arg(.damageAmount, value: .value(1))
                    ]
                ),
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .chooseTarget([.neighbourToTarget])
                    ]
                )
            ]
        )
    }

    static var saved: Card {
        .init(
            id: "saved",
            desc: "Play out your turn. By discarding prevent any player to lose 1 life. In case of save from death, you draw 2 card form hand of saved player or from deck (your choice).",
            canPlay: .otherDamaged,
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .target(.damaged)
                    ]
                ),
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .if(.targetHealthIs1),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var bandidos: Card {
        .init(
            id: "bandidos",
            desc: "Others players may discard 2 cards from hand (1 if he only has one) or loose one life point.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .damage,
                    selectors: [
                        .target(.others),
                        .chooseEventuallyCounterHandCard(count: 2)
                    ]
                )
            ]
        )
    }

    static var poker: Card {
        .init(
            id: "poker",
            desc: "All others players discard a card. If no one discards an Ace card, you can draw 2 cards from the discarded cards.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .discard,
                    selectors: [
                        .target(.others),
                        .chooseCard()
                    ]
                ),
                .init(
                    when: .played,
                    action: .drawDiscard,
                    selectors: [
                        .if(.discardedCardsNotAce),
                        .repeat(.value(2)),
                        .chooseCard(.discarded)
                    ]
                )
            ]
        )
    }

    static var lemat: Card {
        .init(
            id: "lemat",
            desc: "gun, range 1: In your turn, you may use any card like BANG card.",
            attributes: [.weapon: 1],
            playWith: ["bang": ""],
            effects: [
                .equip
            ]
        )
    }

    static var shootgun: Card {
        .init(
            id: "shootgun",
            desc: "gun, range 1: If any player is hit by BANG! card by player with SHOTGUN, that player discard 1 card from hand at his choice.",
            attributes: [.weapon: 1],
            effects: [
                .equip,
                .init(
                    when: .damagingWith("bang"),
                    action: .discard,
                    selectors: [
                        .target(.damaged),
                        .chooseCard(.fromHand)
                    ]
                )
            ]
        )
    }

    static var bounty: Card {
        .init(
            id: "bounty",
            desc: "Play in front any player. Player who succesfully hit player with BOUNTY with BANG! card, he draw a card.",
            effects: [
                .handicap,
                .init(
                    when: .damagedWith("bang"),
                    action: .drawDeck,
                    selectors: [
                        .target(.offender)
                    ]
                )
            ]
        )
    }

    static var rattlesnake: Card {
        .init(
            id: "rattlesnake",
            desc: "Play in front any player. At beginnings of that player's turn, he draw: On Spade, he lose 1 life point, otherwise he does nothing.",
            effects: [
                .handicap,
                .init(
                    when: .turnStarted,
                    action: .draw
                ),
                .init(
                    when: .turnStarted,
                    action: .damage,
                    selectors: [
                        .if(.draw("♠️"))
                    ]
                )
            ]
        )
    }

    static var escape: Card {
        // ⚠️ TODO: Counter any effect
        .init(
            id: "escape",
            desc: "If you are target of card other than BANG! card, you may discard this card to avoid that card's effect."
        )
    }

    static var ghost: Card {
        // ⚠️ TODO: player without health
        .init(
            id: "ghost",
            desc: "Play in front any eliminated player. He return to game without his ability and possibilty to grain or lose any life point. He play as normal player."
        )
    }

    static var coloradoBill: Card {
        .init(
            id: "coloradoBill",
            desc: "Eachtime any player play MISSED! against BANG! card from Colorado: Colorado draw: on Spades, MISSED! is ignored and that player lose 1 life points.",
            effects: [
                .init(
                    when: .targetedHasMissed("bang"),
                    action: .draw
                ),
                .init(
                    when: .targetedHasMissed("bang"),
                    action: .damage,
                    selectors: [
                        .if(.draw("♠️")),
                        .target(.targeted)
                    ]
                )
            ]
        )
    }

    static var evelynShebang: Card {
        // ⚠️ TODO: choose to override default effect
        .init(
            id: "evelynShebang",
            desc: "She may decide not to draw some number of cards in her draw phase. For each card skipped, she shoots a Bang! at a different target in reachable distance."
        )
    }

    static var lemonadeJim: Card {
        .init(
            id: "lemonadeJim",
            desc: "When another player plays BEER card, he may discard any card to refill 1 life point.",
            canPlay: .otherPlayedCardWithName("beer"),
            effects: [
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .chooseCostHandCard()
                    ]
                )
            ]
        )
    }

    static var henryBlock: Card {
        .init(
            id: "henryBlock",
            desc: "Any another player who discards or draw from Henry hand or in front him, is target of BANG.",
            effects: [
                .init(
                    when: .cardStolen,
                    action: .shoot,
                    selectors: [
                        .target(.offender)
                    ]
                ),
                .init(
                    when: .cardDiscarded,
                    action: .shoot,
                    selectors: [
                        .target(.offender)
                    ]
                )
            ]
        )
    }

    static var blackFlower: Card {
        .init(
            id: "blackFlower",
            desc: "Once per turn, she can shoot an extra Bang! by discarding a Clubs card.",
            effects: [
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .if(.playedLessThan(.value(1))),
                        .chooseCostHandCard(.suits("♣️")),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var derSpotBurstRinger: Card {
        .init(
            id: "derSpotBurstRinger",
            desc: "Once per turn, he can play a Bang! card as Gatling.",
            effects: [
                .init(
                    when: .played,
                    action: .shoot,
                    selectors: [
                        .if(.playedLessThan(.value(1))),
                        .chooseCostHandCard(.named("bang")),
                        .target(.others)
                    ]
                )
            ]
        )
    }

    static var tucoFranziskaner: Card {
        .init(
            id: "tucoFranziskaner",
            desc: "During his draw phase, he draw 2 extra cards if he has no blue cards in play.",
            effects: [
                .init(
                    when: .turnStarted,
                    action: .drawDeck,
                    selectors: [
                        .if(.hasNoBlueCardsInPlay),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }
}

extension Effect {
    static var brown: Effect {
        .init(
            when: .played,
            action: .discardSilently,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var equip: Effect {
        .init(
            when: .played,
            action: .equip,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var handicap: Effect {
        .init(
            when: .played,
            action: .handicap,
            selectors: [
                .chooseTarget(),
                .card(.played)
            ]
        )
    }
}
