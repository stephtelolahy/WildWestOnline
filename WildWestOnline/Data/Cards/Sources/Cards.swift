//
//  Cards.swift
//
//
//  Created by Hugues Telolahy on 12/08/2024.
//

// swiftlint:disable no_magic_numbers line_length file_length
import GameCore

public enum Cards {
    /// BANG! THE BULLET
    /// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
    ///
    static let all: [Card] = [
        defaultPlayerAttributes,
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

    static var defaultPlayerAttributes: Card {
        .init(
            name: .defaultPlayerAttributes,
            desc: "Player default attributes",
            setPlayerAttribute: [.weapon: 1]
        )
    }

    static var defaultDraw2CardsOnTurnStarted: Card {
        .init(
            name: .defaultDraw2CardsOnTurnStarted,
            desc: "Draw two cards at the beginning of your turn",
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var defaultDiscardExcessHandOnTurnEnded: Card {
        .init(
            name: .defaultDiscardExcessHandOnTurnEnded,
            desc: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            effects: [
                .init(
                    action: .discard,
                    selectors: [
                        .repeat(.excessHand),
                        .chooseCard(.fromHand)
                    ]
                )
            ]
        )
    }

    static var defaultEliminateOnDamageLethal: Card {
        .init(
            name: .defaultEliminateOnDamageLethal,
            desc: "When you lose your last life point, you are eliminated and your game is over",
            effects: [
                .init(
                    action: .eliminate,
                    when: .damagedLethal
                )
            ]
        )
    }

    static var defaultDiscardAllCardsOnEliminated: Card {
        .init(
            name: .defaultDiscardAllCardsOnEliminated,
            desc: "",
            effects: [
                .init(
                    action: .discard,
                    selectors: [
                        .setCard(.all)
                    ],
                    when: .eliminated
                )
            ]
        )
    }

    static var defaultEndTurnOnEliminated: Card {
        .init(
            name: .defaultEndTurnOnEliminated,
            desc: "",
            effects: [
                .init(
                    action: .endTurn,
                    selectors: [
                        .verify(.actorTurn)
                    ],
                    when: .eliminated
                )
            ]
        )
    }

    static var defaultStartTurnNextOnTurnEnded: Card {
        .init(
            name: .defaultStartTurnNextOnTurnEnded,
            desc: "",
            effects: [
                .init(
                    action: .startTurn,
                    selectors: [
                        .setTarget(.next)
                    ],
                    when: .turnEnded
                )
            ]
        )
    }

    static var defaultDiscardPreviousWeaponOnPlayed: Card {
        .init(
            name: .defaultDiscardPreviousWeaponOnPlayed,
            desc: "",
            effects: [
                .init(
                    action: .discard,
                    selectors: [
                        .setCard(.inPlayWithAttr(.weapon))
                    ],
                    when: .playedCardWithAttr(.weapon)
                )
            ]
        )
    }

    static var defaultDiscardBeerOnDamagedLethal: Card {
        .init(
            name: .defaultDiscardBeerOnDamagedLethal,
            desc: "When you lose your last life point, you are eliminated and your game is over, unless you immediately play a Beer",
            canPlay: .damagedLethal,
            effects: [
                .init(
                    action: .heal,
                    selectors: [
                        .verify(.playersAtLeast(3)),
                        .chooseCostHandCard(.named(.beer))
                    ]
                )
            ]
        )
    }

    // MARK: - Bang

    static var beer: Card {
        .init(
            name: .beer,
            desc: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            effects: [
                .brown,
                .init(
                    action: .heal,
                    selectors: [
                        .verify(.playersAtLeast(3))
                    ]
                )
            ]
        )
    }

    static var saloon: Card {
        .init(
            name: .saloon,
            desc: "All players in play regain one life point.",
            effects: [
                .brown,
                .init(
                    action: .heal,
                    selectors: [
                        .setTarget(.all)
                    ]
                )
            ]
        )
    }

    static var stagecoach: Card {
        .init(
            name: .stagecoach,
            desc: "Draw two cards from the top of the deck.",
            effects: [
                .brown,
                .init(
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
            name: .wellsFargo,
            desc: "Draw three cards from the top of the deck.",
            effects: [
                .brown,
                .init(
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
            name: .catBalou,
            desc: "Force “any one player” to “discard a card”, regardless of the distance.",
            effects: [
                .brown,
                .init(
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
            name: .panic,
            desc: "Draw a card from a player at distance 1",
            effects: [
                .brown,
                .init(
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
            name: .bang,
            desc: "reduce other players’s life points",
            effects: [
                .brown,
                .init(
                    action: .shoot,
                    selectors: [
                        .verify(.limitPerTurn(1)),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var missed: Card {
        .init(
            name: .missed,
            desc: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            canPlay: .shot,
            effects: [
                .brown,
                .init(
                    action: .missed
                )
            ]
        )
    }

    static var gatling: Card {
        .init(
            name: .gatling,
            desc: "shoots to all the other players, regardless of the distance",
            effects: [
                .brown,
                .init(
                    action: .shoot,
                    selectors: [
                        .setTarget(.others)
                    ]
                )
            ]
        )
    }

    static var indians: Card {
        .init(
            name: .indians,
            desc: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            effects: [
                .brown,
                .init(
                    action: .damage,
                    selectors: [
                        .setTarget(.others),
                        .chooseEventuallyCounterHandCard(.named(.bang))
                    ]
                )
            ]
        )
    }

    static var duel: Card {
        .init(
            name: .duel,
            desc: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            effects: [
                .brown,
                .init(
                    action: .damage,
                    selectors: [
                        .chooseTarget(),
                        .chooseEventuallyReverseHandCard(.named(.bang))
                    ]
                )
            ]
        )
    }

    static var generalStore: Card {
        .init(
            name: .generalStore,
            desc: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            effects: [
                .brown,
                .init(
                    action: .discover,
                    selectors: [
                        .setAttribute(.discoverAmount, value: .activePlayers)
                    ]
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .setTarget(.all),
                        .chooseCard(.discovered)
                    ]
                )
            ]
        )
    }

    static var schofield: Card {
        .init(
            name: .schofield,
            desc: "can hit targets at a distance of 2.",
            setPlayerAttribute: [.weapon: 2],
            effects: [.equip]
        )
    }

    static var remington: Card {
        .init(
            name: .remington,
            desc: "can hit targets at a distance of 3.",
            setPlayerAttribute: [.weapon: 3],
            effects: [.equip]
        )
    }

    static var revCarabine: Card {
        .init(
            name: .revCarabine,
            desc: "can hit targets at a distance of 4.",
            setPlayerAttribute: [.weapon: 4],
            effects: [.equip]
        )
    }

    static var winchester: Card {
        .init(
            name: .winchester,
            desc: "can hit targets at a distance of 5.",
            setPlayerAttribute: [.weapon: 5],
            effects: [.equip]
        )
    }

    static var volcanic: Card {
        .init(
            name: .volcanic,
            desc: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            setPlayerAttribute: [.weapon: 1],
            setActionAttribute: [.bang: [.ignoreLimitPerTurn: 0]],
            effects: [.equip]
        )
    }

    static var scope: Card {
        .init(
            name: .scope,
            desc: "you see all the other players at a distance decreased by 1",
            increasePlayerAttribute: [.magnifying: 1],
            effects: [.equip]
        )
    }

    static var mustang: Card {
        .init(
            name: .mustang,
            desc: "the distance between other players and you is increased by 1",
            increasePlayerAttribute: [.remoteness: 1],
            effects: [.equip]
        )
    }

    static var jail: Card {
        .init(
            name: .jail,
            desc: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            effects: [
                .handicap,
                .init(
                    action: .draw,
                    when: .turnStarted
                ),
                .init(
                    action: .endTurn,
                    selectors: [
                        .verify(.not(.draw("♥️")))
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .discard,
                    selectors: [
                        .setCard(.played)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var barrel: Card {
        .init(
            name: .barrel,
            desc: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            effects: [
                .equip,
                .init(
                    action: .draw,
                    when: .shot
                ),
                .init(
                    action: .missed,
                    selectors: [
                        .verify(.draw("♥️"))
                    ],
                    when: .shot
                )
            ]
        )
    }

    static var dynamite: Card {
        .init(
            name: .dynamite,
            desc: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            effects: [
                .equip,
                .init(
                    action: .draw,
                    when: .turnStarted
                ),
                .init(
                    action: .handicap,
                    selectors: [
                        .verify(.not(.draw("[2-9]♠️"))),
                        .setCard(.played),
                        .setTarget(.next)
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .damage,
                    selectors: [
                        .verify(.draw("[2-9]♠️")),
                        .setAttribute(.damageAmount, value: .value(3))
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .discard,
                    selectors: [
                        .verify(.draw("[2-9]♠️")),
                        .setCard(.played)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var willyTheKid: Card {
        .init(
            name: .willyTheKid,
            desc: "he can play any number of BANG! cards during his turn.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.bang: [.ignoreLimitPerTurn: 0]]
        )
    }

    static var roseDoolan: Card {
        .init(
            name: .roseDoolan,
            desc: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            setPlayerAttribute: [.maxHealth: 4],
            increasePlayerAttribute: [.magnifying: 1]
        )
    }

    static var paulRegret: Card {
        .init(
            name: .paulRegret,
            desc: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            setPlayerAttribute: [.maxHealth: 3],
            increasePlayerAttribute: [.remoteness: 1]
        )
    }

    static var jourdonnais: Card {
        .init(
            name: .jourdonnais,
            desc: "he is considered to have a Barrel card in play at all times; he can \"draw!\" when he is the target of a BANG!, and on a Heart he is missed. If he has another real Barrel card in play, he can count both of them, giving him two chances to cancel the BANG! before playing a Missed! card.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .draw,
                    when: .shot
                ),
                .init(
                    action: .missed,
                    selectors: [
                        .verify(.draw("♥️"))
                    ],
                    when: .shot
                )
            ]
        )
    }

    static var bartCassidy: Card {
        .init(
            name: .bartCassidy,
            desc: "each time he loses a life point, he immediately draws a card from the deck.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.damage)
                    ],
                    when: .damaged
                )
            ]
        )
    }

    static var elGringo: Card {
        .init(
            name: .elGringo,
            desc: "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player.",
            setPlayerAttribute: [.maxHealth: 3],
            effects: [
                .init(
                    action: .steal,
                    selectors: [
                        .setTarget(.offender),
                        .repeat(.damage)
                    ],
                    when: .damaged
                )
            ]
        )
    }

    static var suzyLafayette: Card {
        .init(
            name: .suzyLafayette,
            desc: "as soon as she has no cards in her hand, she draws a card from the draw pile.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .drawDeck,
                    when: .handEmpty
                )
            ]
        )
    }

    static var sidKetchum: Card {
        .init(
            name: .sidKetchum,
            desc: "at any time, he may discard 2 cards from his hand to regain one life point. If he is willing and able, he can use this ability more than once at a time.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
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
            name: .vultureSam,
            desc: "whenever a character is eliminated from the game, Sam takes all the cards that player had in his hand and in play, and adds them to his hand.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .steal,
                    selectors: [
                        .setTarget(.eliminated),
                        .setCard(.all)
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var slabTheKiller: Card {
        .init(
            name: .slabTheKiller,
            desc: "players trying to cancel his BANG! cards need to play 2 Missed! cards. The Barrel effect, if successfully used, only counts as one Missed!.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.bang: [.shootRequiredMisses: 2]]
        )
    }

    static var luckyDuke: Card {
        .init(
            name: .luckyDuke,
            desc: "each time he is required to \"draw!\", he flips the top two cards from the deck, and chooses the result he prefers. Discard both cards afterwards.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["": [.drawAmount: 2]]
        )
    }

    static var calamityJanet: Card {
        .init(
            name: .calamityJanet,
            desc: "she can use BANG! cards as Missed! cards and vice versa. If she plays a Missed! card as a BANG!, she cannot play another BANG! card that turn (unless she has a Volcanic in play).",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [
                "missed": [.playableAsBang: 0],
                "bang": [.playableAsMissed: 0]
            ]
        )
    }

    static var kitCarlson: Card {
        .init(
            name: .kitCarlson,
            desc: "during the phase 1 of his turn, he looks at the top three cards of the deck: he chooses 2 to draw, and puts the other one back on the top of the deck, face down.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    action: .discover,
                    selectors: [
                        .setAttribute(.discoverAmount, value: .value(3))
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var blackJack: Card {
        .init(
            name: .blackJack,
            desc: "during the phase 1 of his turn, he must show the second card he draws: if it's Heart or Diamonds (just like a \"draw!\", he draws one additional card (without revealing it).",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .showLastDraw,
                    when: .turnStarted
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .verify(.draw("(♥️)|(♦️)"))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var jesseJones: Card {
        .init(
            name: .jesseJones,
            desc: "during phase 1 of his turn, he may choose to draw the first card from the deck, or randomly from the hand of any other player. Then he draws the second card from the deck.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    action: .drawDiscard,
                    when: .turnStarted
                ),
                .init(
                    action: .drawDeck,
                    when: .turnStarted
                )
            ]
        )
    }

    static var pedroRamirez: Card {
        .init(
            name: .pedroRamirez,
            desc: "during the phase 1 of his turn, he may choose to draw the first card from the top of the discard pile or from the deck. Then, he draws the second card from the deck.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    action: .steal,
                    selectors: [
                        .chooseTarget([.havingHandCard]),
                        .chooseCard()
                    ],
                    when: .turnStarted
                ),
                .init(
                    action: .drawDeck,
                    when: .turnStarted
                )
            ]
        )
    }

    // MARK: - Dodge city

    static var punch: Card {
        .init(
            name: .punch,
            desc: "Acts as a Bang! with a range of one.",
            effects: [
                .brown,
                .init(
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
            name: .dodge,
            desc: "Acts as a Missed!, but allows the player to draw a card.",
            canPlay: .shot,
            effects: [
                .brown,
                .init(
                    action: .missed
                ),
                .init(
                    action: .drawDeck
                )
            ]
        )
    }

    static var springfield: Card {
        .init(
            name: .springfield,
            desc: "The player must discard one additional card, and then the card acts as a Bang! with unlimited range.",
            effects: [
                .brown,
                .init(
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
            name: .hideout,
            desc: "Others view you at distance +1",
            increasePlayerAttribute: [.remoteness: 1]
        )
    }

    static var binocular: Card {
        .init(
            name: .binocular,
            desc: "you view others at distance -1",
            increasePlayerAttribute: [.magnifying: 1]
        )
    }

    static var whisky: Card {
        .init(
            name: .whisky,
            desc: "The player must discard one additional card, to heal two health.",
            effects: [
                .brown,
                .init(
                    action: .heal,
                    selectors: [
                        .chooseCostHandCard(),
                        .setAttribute(.healAmount, value: .value(2))
                    ]
                )
            ]
        )
    }

    static var tequila: Card {
        .init(
            name: .tequila,
            desc: "The player must discard one additional card, to heal any player one health.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .brown,
                .init(
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
            name: .ragTime,
            desc: "The player must discard one additional card to steal a card from any other player.",
            effects: [
                .brown,
                .init(
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
            name: .brawl,
            desc: "The player must discard one additional card to cause all other players to discard one card.",
            effects: [
                .brown,
                .init(
                    action: .discard,
                    selectors: [
                        .chooseCostHandCard(),
                        .setTarget(.all),
                        .chooseCard()
                    ]
                )
            ]
        )
    }

    static var elenaFuente: Card {
        .init(
            name: .elenaFuente,
            desc: "She may use any card in hand as Missed!.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: ["": [.playableAsMissed: 0]]
        )
    }

    static var seanMallory: Card {
        .init(
            name: .seanMallory,
            desc: "He may hold in his hand up to 10 cards.",
            setPlayerAttribute: [.maxHealth: 3, .handLimit: 10]
        )
    }

    static var tequilaJoe: Card {
        .init(
            name: .tequilaJoe,
            desc: "Each time he plays a Beer, he regains 2 life points instead of 1.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.beer: [.healAmount: 2]]
        )
    }

    static var pixiePete: Card {
        .init(
            name: .pixiePete,
            desc: "During phase 1 of his turn, he draws 3 cards instead of 2.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var billNoface: Card {
        .init(
            name: .billNoface,
            desc: "He draws 1 card, plus 1 card for each wound he has.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    action: .drawDeck,
                    when: .turnStarted
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.wound)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var gregDigger: Card {
        .init(
            name: .gregDigger,
            desc: "Each time another player is eliminated, he regains 2 life points.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .heal,
                    selectors: [
                        .setAttribute(.healAmount, value: .value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var herbHunter: Card {
        .init(
            name: .herbHunter,
            desc: "Each time another player is eliminated, he draws 2 extra cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var mollyStark: Card {
        .init(
            name: .mollyStark,
            desc: "Each time she uses a card from her hand out of turn, she draw a card.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .verify(.limitPerTurn(2))
                    ],
                    when: .playedCardOutOfTurn
                )
            ]
        )
    }

    static var joseDelgado: Card {
        .init(
            name: .joseDelgado,
            desc: "Twice in his turn, he may discard a blue card from the hand to draw 2 cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .verify(.limitPerTurn(2)),
                        .chooseCostHandCard(.isBlue),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var chuckWengam: Card {
        .init(
            name: .chuckWengam,
            desc: "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .damage
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var docHolyday: Card {
        .init(
            name: .docHolyday,
            desc: "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    action: .shoot,
                    selectors: [
                        .verify(.limitPerTurn(1)),
                        .chooseCostHandCard(count: 2),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var apacheKid: Card {
        .init(
            name: .apacheKid,
            desc: "Cards of Diamond played by other players do not affect him",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["♦️": [.playedByOtherHasNoEffect: 0]]
        )
    }

    static var belleStar: Card {
        .init(
            name: .belleStar,
            desc: "During her turn, cards in play in front of other players have no effect. ",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["": [.inPlayOfOtherHasNoEffect: 0]]
        )
    }

    static var patBrennan: Card {
        .init(
            name: .patBrennan,
            desc: "Instead of drawing normally, he may draw only one card in play in front of any one player.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    action: .steal,
                    selectors: [
                        .chooseTarget([.havingInPlayCard]),
                        .chooseCard(.inPlay)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var veraCuster: Card {
        // ⚠️ TODO: set round ability
        .init(
            name: .veraCuster,
            desc: "For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn",
            setPlayerAttribute: [.maxHealth: 3]
        )
    }

    // MARK: - The Valley of Shadows

    static var lastCall: Card {
        .init(
            name: .lastCall,
            desc: "Refill 1 life point even in game last 2 players.",
            effects: [
                .brown,
                .init(
                    action: .heal
                )
            ]
        )
    }

    static var tornado: Card {
        .init(
            name: .tornado,
            desc: "Each player discards a card from their hand (if possible), then draw 2 cards from the deck",
            effects: [
                .brown,
                .init(
                    action: .drawDeck,
                    selectors: [
                        .setTarget(.all),
                        .chooseCostHandCard(),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var backfire: Card {
        .init(
            name: .backfire,
            desc: "Count as MISSED!. Player who shot you, is now target of BANG!.",
            effects: [
                .brown,
                .init(
                    action: .missed
                ),
                .init(
                    action: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ]
                )
            ]
        )
    }

    static var tomahawk: Card {
        .init(
            name: .tomahawk,
            desc: "Bang at distance 2. But it can be used at distance 1",
            effects: [
                .brown,
                .init(
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
            name: .aim,
            desc: "Play with Bang card. If defending player doesn't miss, he loses 2 life points instead",
            setActionAttribute: [.bang: [.damageAmount: 2]],
            canPlay: .playedCardWithName(.bang),
            effects: [
                .brown
            ]
        )
    }

    static var faning: Card {
        .init(
            name: .faning,
            desc: "Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).",
            setActionAttribute: ["faning": [.labeledAsBang: 0]],
            effects: [
                .brown,
                .init(
                    action: .shoot,
                    selectors: [
                        .verify(.limitPerTurn(1)),
                        .chooseTarget([.atDistanceReachable])
                    ]
                ),
                .init(
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
            name: .saved,
            desc: "Play out your turn. By discarding prevent any player to lose 1 life. In case of save from death, you draw 2 card form hand of saved player or from deck (your choice).",
            canPlay: .otherDamaged,
            effects: [
                .brown,
                .init(
                    action: .heal,
                    selectors: [
                        .setTarget(.damaged)
                    ]
                ),
                .init(
                    action: .drawDeck,
                    selectors: [
                        .verify(.targetHealthIs1),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var bandidos: Card {
        .init(
            name: .bandidos,
            desc: "Others players may discard 2 cards from hand (1 if he only has one) or loose one life point.",
            effects: [
                .brown,
                .init(
                    action: .damage,
                    selectors: [
                        .setTarget(.others),
                        .chooseEventuallyCounterHandCard(count: 2)
                    ]
                )
            ]
        )
    }

    static var poker: Card {
        .init(
            name: .poker,
            desc: "All others players discard a card. If no one discards an Ace card, you can draw 2 cards from the discarded cards.",
            effects: [
                .brown,
                .init(
                    action: .discard,
                    selectors: [
                        .setTarget(.others),
                        .chooseCard()
                    ]
                ),
                .init(
                    action: .drawDiscard,
                    selectors: [
                        .verify(.discardedCardsNotAce),
                        .repeat(.value(2)),
                        .chooseCard(.discarded)
                    ]
                )
            ]
        )
    }

    static var lemat: Card {
        .init(
            name: .lemat,
            desc: "gun, range 1: In your turn, you may use any card like BANG card.",
            setPlayerAttribute: [.weapon: 1],
            setActionAttribute: ["": [.playableAsBang: 0]]
        )
    }

    static var shootgun: Card {
        .init(
            name: .shootgun,
            desc: "gun, range 1: If any player is hit by BANG! card by player with SHOTGUN, that player discard 1 card from hand at his choice.",
            setPlayerAttribute: [.weapon: 1],
            effects: [
                .equip,
                .init(
                    action: .discard,
                    selectors: [
                        .setTarget(.damaged),
                        .chooseCard(.fromHand)
                    ],
                    when: .otherDamagedByYourCard(.bang)
                )
            ]
        )
    }

    static var bounty: Card {
        .init(
            name: .bounty,
            desc: "Play in front any player. Player who succesfully hit player with BOUNTY with BANG! card, he draw a card.",
            effects: [
                .handicap,
                .init(
                    action: .drawDeck,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .damagedByCard(.bang)
                )
            ]
        )
    }

    static var rattlesnake: Card {
        .init(
            name: .rattlesnake,
            desc: "Play in front any player. At beginnings of that player's turn, he draw: On Spade, he lose 1 life point, otherwise he does nothing.",
            effects: [
                .handicap,
                .init(
                    action: .draw,
                    when: .turnStarted
                ),
                .init(
                    action: .damage,
                    selectors: [
                        .verify(.draw("♠️"))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var escape: Card {
        .init(
            name: .escape,
            desc: "If you are target of card other than BANG! card, you may discard this card to avoid that card's effect.",
            effects: [
                .init(
                    action: .counter,
                    when: .targetedWithCardOthertThan(.bang)
                )
            ]
        )
    }

    static var ghost: Card {
        .init(
            name: .ghost,
            desc: "Play in front any eliminated player. He return to game without his ability and possibilty to grain or lose any life point. He play as normal player.",
            setPlayerAttribute: [.ghost: 0]
        )
    }

    static var coloradoBill: Card {
        .init(
            name: .coloradoBill,
            desc: "Eachtime any player play MISSED! against BANG! card from Colorado: Colorado draw: on Spades, MISSED! is ignored and that player lose 1 life points.",
            effects: [
                .init(
                    action: .draw,
                    when: .otherMissedYourShoot(.bang)
                ),
                .init(
                    action: .damage,
                    selectors: [
                        .verify(.draw("♠️")),
                        .setTarget(.targeted)
                    ],
                    when: .otherMissedYourShoot(.bang)
                )
            ]
        )
    }

    static var evelynShebang: Card {
        .init(
            name: .evelynShebang,
            desc: "She may decide not to draw some number of cards in her draw phase. For each card skipped, she shoots a Bang! at a different target in reachable distance.",
            setActionAttribute: [.defaultDraw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    action: .shoot,
                    selectors: [
                        .repeat(.value(2)),
                        .chooseTarget([.atDistanceReachable])
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var lemonadeJim: Card {
        .init(
            name: .lemonadeJim,
            desc: "When another player plays BEER card, he may discard any card to refill 1 life point.",
            canPlay: .otherPlayedCard(.beer),
            effects: [
                .init(
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
            name: .henryBlock,
            desc: "Any another player who discards or draw from Henry hand or in front him, is target of BANG.",
            effects: [
                .init(
                    action: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardStolen
                ),
                .init(
                    action: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardDiscarded
                )
            ]
        )
    }

    static var blackFlower: Card {
        .init(
            name: .blackFlower,
            desc: "Once per turn, she can shoot an extra Bang! by discarding a Clubs card.",
            effects: [
                .init(
                    action: .shoot,
                    selectors: [
                        .verify(.limitPerTurn(1)),
                        .chooseCostHandCard(.suits("♣️")),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var derSpotBurstRinger: Card {
        .init(
            name: .derSpotBurstRinger,
            desc: "Once per turn, he can play a Bang! card as Gatling.",
            effects: [
                .init(
                    action: .shoot,
                    selectors: [
                        .verify(.limitPerTurn(1)),
                        .chooseCostHandCard(.named(.bang)),
                        .setTarget(.others)
                    ]
                )
            ]
        )
    }

    static var tucoFranziskaner: Card {
        .init(
            name: .tucoFranziskaner,
            desc: "During his draw phase, he draw 2 extra cards if he has no blue cards in play.",
            effects: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .verify(.hasNoBlueCardsInPlay),
                        .repeat(.value(2))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }
}

extension Effect {
    static var brown: Effect {
        .init(
            action: .discardSilently,
            selectors: [
                .setCard(.played)
            ]
        )
    }

    static var equip: Effect {
        .init(
            action: .equip,
            selectors: [
                .setCard(.played)
            ]
        )
    }

    static var handicap: Effect {
        .init(
            action: .handicap,
            selectors: [
                .chooseTarget(),
                .setCard(.played)
            ]
        )
    }
}
