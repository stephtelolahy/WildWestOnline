//
//  DraftCards.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 30/11/2025.
//
// swiftlint:disable file_length

/*
    static var elenaFuente: Self {
        .init(
            name: .elenaFuente,
            description: "She may use any card in hand as Missed!.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: ["": [.playableAsMissed: 0]]
        )
    }

    static var seanMallory: Self {
        .init(
            name: .seanMallory,
            description: "He may hold in his hand up to 10 cards.",
            setPlayerAttribute: [.maxHealth: 3, .handLimit: 10]
        )
    }

    static var tequilaJoe: Self {
        .init(
            name: .tequilaJoe,
            description: "Each time he plays a Beer, he regains 2 life points instead of 1.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.beer: [.healAmount: 2]]
        )
    }

    static var pixiePete: Self {
        .init(
            name: .pixiePete,
            description: "During phase 1 of his turn, he draws 3 cards instead of 2.",
            setPlayerAttribute: [.maxHealth: 3],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var billNoface: Self {
        .init(
            name: .billNoface,
            description: "He draws 1 card, plus 1 card for each wound he has.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.silent: 0]],
            effects: [
                .init(
                    name: .drawDeck,
                    when: .turnStarted
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.wound)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var gregDigger: Self {
        .init(
            name: .gregDigger,
            description: "Each time another player is eliminated, he regains 2 life points.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .heal,
                    selectors: [
                        .setAttribute(.healAmount, value: .value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var herbHunter: Self {
        .init(
            name: .herbHunter,
            description: "Each time another player is eliminated, he draws 2 extra cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ],
                    when: .otherEliminated
                )
            ]
        )
    }

    static var mollyStark: Self {
        .init(
            name: .mollyStark,
            description: "Each time she uses a card from her hand out of turn, she draw a card.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.limitPerTurn(2))
                    ],
                    when: .playedCardOutOfTurn
                )
            ]
        )
    }

    static var joseDelgado: Self {
        .init(
            name: .joseDelgado,
            description: "Twice in his turn, he may discard a blue card from the hand to draw 2 cards.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.limitPerTurn(2)),
                        .chooseCostHandCard(.isBlue),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var chuckWengam: Self {
        .init(
            name: .chuckWengam,
            description: "During his turn, he may choose to lose 1 life point to draw 2 cards. However, the last life point cannot be lost.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .damage
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var docHolyday: Self {
        .init(
            name: .docHolyday,
            description: "Once during his turn, he may discard 2 cards from the hand to shoot a Bang!.",
            setPlayerAttribute: [.maxHealth: 4],
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(count: 2),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var apacheKid: Self {
        .init(
            name: .apacheKid,
            description: "Cards of Diamond played by other players do not affect him",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["♦️": [.playedByOtherHasNoEffect: 0]]
        )
    }

    static var belleStar: Self {
        .init(
            name: .belleStar,
            description: "During her turn, cards in play in front of other players have no effect. ",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: ["": [.inPlayOfOtherHasNoEffect: 0]]
        )
    }

    static var patBrennan: Self {
        .init(
            name: .patBrennan,
            description: "Instead of drawing normally, he may draw only one card in play in front of any one player.",
            setPlayerAttribute: [.maxHealth: 4],
            setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    name: .steal,
                    selectors: [
                        .chooseTarget([.havingInPlayCard]),
                        .chooseCard(.inPlay)
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var veraCuster: Self {
        .init(
            name: .veraCuster,
            description: "For a whole round, she gains the same ability of another character in play of her choice until the beginning of her next turn",
            setPlayerAttribute: [.maxHealth: 3]
        )
    }

    // MARK: - The Valley of Shadows

    static var lastCall: Self {
        .init(
            name: .lastCall,
            description: "Refill 1 life point even in game last 2 players.",
            effects: [
                .collectible,
                .init(
                    name: .heal
                )
            ]
        )
    }

    static var tornado: Self {
        .init(
            name: .tornado,
            description: "Each player discards a card from their hand (if possible), then draw 2 cards from the deck",
            effects: [
                .collectible,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .setTarget(.all),
                        .chooseCostHandCard(),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var backfire: Self {
        .init(
            name: .backfire,
            description: "Count as MISSED!. Player who shot you, is now target of BANG!.",
            effects: [
                .collectible,
                .init(
                    name: .missed
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ]
                )
            ]
        )
    }

    static var tomahawk: Self {
        .init(
            name: .tomahawk,
            description: "Bang at distance 2. But it can be used at distance 1",
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseTarget([.atDistance(2)])
                    ]
                )
            ]
        )
    }

    static var aim: Self {
        .init(
            name: .aim,
            description: "Play with Bang card. If defending player doesn't miss, he loses 2 life points instead",
            setActionAttribute: [.bang: [.damageAmount: 2]],
            canPlay: .playedCardWithName(.bang),
            effects: [
                .playable
            ]
        )
    }

    static var faning: Self {
        .init(
            name: .faning,
            description: "Count as your normal bang per turn. You hit addional player at distance 1 from 1st target(except you).",
            setActionAttribute: ["faning": [.labeledAsBang: 0]],
            effects: [
                .collectible,
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseTarget([.atDistanceReachable])
                    ]
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .chooseTarget([.neighbourToTarget])
                    ]
                )
            ]
        )
    }

    static var saved: Self {
        .init(
            name: .saved,
            description: "Play out your turn. By discarding prevent any player to lose 1 life. In case of save from death, you draw 2 card form hand of saved player or from deck (your choice).",
            canPlay: .otherDamaged,
            effects: [
                .collectible,
                .init(
                    name: .heal,
                    selectors: [
                        .setTarget(.damaged)
                    ]
                ),
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.targetHealthIs1),
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var bandidos: Self {
        .init(
            name: .bandidos,
            description: "Others players may discard 2 cards from hand (1 if he only has one) or loose one life point.",
            effects: [
                .collectible,
                .init(
                    name: .damage,
                    selectors: [
                        .setTarget(.others),
                        .chooseEventuallyCounterHandCard(count: 2)
                    ]
                )
            ]
        )
    }

    static var poker: Self {
        .init(
            name: .poker,
            description: "All others players discard a card. If no one discards an Ace card, you can draw 2 cards from the discarded cards.",
            effects: [
                .collectible,
                .init(
                    name: .discard,
                    selectors: [
                        .setTarget(.others),
                        .chooseCard()
                    ]
                ),
                .init(
                    name: .drawDiscard,
                    selectors: [
                        .require(.discardedCardsNotAce),
                        .repeat(.value(2)),
                        .chooseCard(.discarded)
                    ]
                )
            ]
        )
    }

    static var lemat: Self {
        .init(
            name: .lemat,
            description: "gun, range 1: In your turn, you may use any card like BANG card.",
            setPlayerAttribute: [.weapon: 1],
            setActionAttribute: ["": [.playableAsBang: 0]]
        )
    }

    static var shootgun: Self {
        .init(
            name: .shootgun,
            description: "gun, range 1: If any player is hit by BANG! card by player with SHOTGUN, that player discard 1 card from hand at his choice.",
            setPlayerAttribute: [.weapon: 1],
            effects: [
                .equip,
                .init(
                    name: .discard,
                    selectors: [
                        .setTarget(.damaged),
                        .chooseCard(.fromHand)
                    ],
                    when: .otherDamagedByYourCard(.bang)
                )
            ]
        )
    }

    static var bounty: Self {
        .init(
            name: .bounty,
            description: "Play in front any player. Player who succesfully hit player with BOUNTY with BANG! card, he draw a card.",
            effects: [
                .handicap,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .damagedByCard(.bang)
                )
            ]
        )
    }

    static var rattlesnake: Self {
        .init(
            name: .rattlesnake,
            description: "Play in front any player. At beginnings of that player's turn, he draw: On Spade, he lose 1 life point, otherwise he does nothing.",
            effects: [
                .handicap,
                .init(
                    name: .draw,
                    when: .turnStarted
                ),
                .init(
                    name: .damage,
                    selectors: [
                        .require(.draw("♠️"))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var escape: Self {
        .init(
            name: .escape,
            description: "If you are target of card other than BANG! card, you may discard this card to avoid that card's effect.",
            effects: [
                .init(
                    name: .counter,
                    when: .targetedWithCardOthertThan(.bang)
                )
            ]
        )
    }

    static var ghost: Self {
        .init(
            name: .ghost,
            description: "Play in front any eliminated player. He return to game without his ability and possibilty to grain or lose any life point. He play as normal player.",
            setPlayerAttribute: [.ghost: 0]
        )
    }

    static var coloradoBill: Self {
        .init(
            name: .coloradoBill,
            description: "Eachtime any player play MISSED! against BANG! card from Colorado: Colorado draw: on Spades, MISSED! is ignored and that player lose 1 life points.",
            effects: [
                .init(
                    name: .draw,
                    when: .otherMissedYourShoot(.bang)
                ),
                .init(
                    name: .damage,
                    selectors: [
                        .require(.draw("♠️")),
                        .setTarget(.targeted)
                    ],
                    when: .otherMissedYourShoot(.bang)
                )
            ]
        )
    }

    static var evelynShebang: Self {
        .init(
            name: .evelynShebang,
            description: "She may decide not to draw some number of cards in her draw phase. For each card skipped, she shoots a Bang! at a different target in reachable distance.",
            setActionAttribute: [.draw2CardsOnTurnStarted: [.eventuallySilent: 0]],
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .repeat(.value(2)),
                        .chooseTarget([.atDistanceReachable])
                    ],
                    when: .turnStarted
                )
            ]
        )
    }

    static var lemonadeJim: Self {
        .init(
            name: .lemonadeJim,
            description: "When another player plays BEER card, he may discard any card to refill 1 life point.",
            canPlay: .otherPlayedCard(.beer),
            effects: [
                .init(
                    name: .heal,
                    selectors: [
                        .chooseCostHandCard()
                    ]
                )
            ]
        )
    }

    static var henryBlock: Self {
        .init(
            name: .henryBlock,
            description: "Any another player who discards or draw from Henry hand or in front him, is target of BANG.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardStolen
                ),
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.offender)
                    ],
                    when: .cardDiscarded
                )
            ]
        )
    }

    static var blackFlower: Self {
        .init(
            name: .blackFlower,
            description: "Once per turn, she can shoot an extra Bang! by discarding a Clubs card.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(.suits("♣️")),
                        .chooseTarget([.atDistanceReachable])
                    ]
                )
            ]
        )
    }

    static var derSpotBurstRinger: Self {
        .init(
            name: .derSpotBurstRinger,
            description: "Once per turn, he can play a Bang! card as Gatling.",
            effects: [
                .init(
                    name: .shoot,
                    selectors: [
                        .require(.limitPerTurn(1)),
                        .chooseCostHandCard(.named(.bang)),
                        .setTarget(.others)
                    ]
                )
            ]
        )
    }

    static var tucoFranziskaner: Self {
        .init(
            name: .tucoFranziskaner,
            description: "During his draw phase, he draw 2 extra cards if he has no blue cards in play.",
            effects: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .require(.hasNoBlueCardsInPlay),
                        .repeat(.value(2))
                    ],
                    when: .turnStarted
                )
            ]
        )
    }
 */
