//
//  Cards.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable file_length line_length
import GameCore

/// BANG! THE BULLET
/// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
public enum Cards {
    public static let all: [Card] = [
        .endTurn,
        .discardCounterCardOnShot,
        .discardExcessHandOnTurnEnded,
        .draw2CardsOnTurnStarted,
        .startTurnNextOnTurnEnded,
        .eliminateOnDamageLethal,
        .endGameOnEliminated,
        .discardAllCardsOnEliminated,
        .endTurnOnEliminated,
        .stagecoach,
        .wellsFargo,
        .beer,
        .saloon,
        .catBalou,
        .panic,
        .generalStore,
        .bang,
        .missed,
        .gatling,
        .indians,
        .duel,
        .schofield,
        .remington,
        .revCarabine,
        .winchester,
        .volcanic,
        .scope,
        .mustang,
        .barrel,
        .dynamite,
        .jail,
        .willyTheKid,
        .roseDoolan,
        .paulRegret,
        .bartCassidy,
        .elGringo,
        .suzyLafayette,
    ]
}

private extension Card {
    static var endTurn: Self {
        .initJSON(
            name: .endTurn,
            type: .ability,
            description: "End turn",
            effects: [
                .init(
                    trigger: .cardPrePlayed,
                    action: .endTurn
                )
            ]
        )
    }

    static var discardCounterCardOnShot: Self {
        .initJSON(
            name: .discardCounterCardOnShot,
            type: .ability,
            description: "Discard counter card on shot",
            effects: [
                .init(
                    trigger: .shot,
                    action: .counterShot,
                    selectors: [
                        .chooseOne(.optionalCostCard([.canCounterShot]))
                    ]
                )
            ]
        )
    }

    static var discardExcessHandOnTurnEnded: Self {
        .initJSON(
            name: .discardExcessHandOnTurnEnded,
            type: .ability,
            description: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            effects: [
                .init(
                    trigger: .turnEnded,
                    action: .discardHand,
                    selectors: [
                        .repeat(.playerExcessHandSize),
                        .chooseOne(.targetCard([.isFromHand]))
                    ]
                )
            ]
        )
    }

    static var startTurnNextOnTurnEnded: Self {
        .initJSON(
            name: .startTurnNextOnTurnEnded,
            type: .ability,
            description: "Start next player's turn",
            effects: [
                .init(
                    trigger: .turnEnded,
                    action: .startTurn,
                    selectors: [
                        .setTarget(.nextPlayer)
                    ]
                )
            ]
        )
    }

    static var draw2CardsOnTurnStarted: Self {
        .init(
            name: .draw2CardsOnTurnStarted,
            type: .ability,
            description: "Draw two cards at the beginning of your turn",
            behaviour: [
                .turnStarted: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.fixed(2))
                        ]
                    )
                ]
            ]
        )
    }

    static var eliminateOnDamageLethal: Self {
        .init(
            name: .eliminateOnDamageLethal,
            type: .ability,
            description: "When you lose your last life point, you are eliminated and your game is over",
            behaviour: [
                .damagedLethal: [
                    .init(
                        name: .eliminate
                    )
                ]
            ]
        )
    }

    static var endGameOnEliminated: Self {
        .init(
            name: .endGameOnEliminated,
            type: .ability,
            description: "End game when last player is eliminated",
            behaviour: [
                .eliminated: [
                    .init(
                        name: .endGame,
                        selectors: [.require(.isGameOver)]
                    )
                ]
            ]
        )
    }

    static var discardAllCardsOnEliminated: Self {
        .init(
            name: .discardAllCardsOnEliminated,
            type: .ability,
            description: "Discard all cards when eliminated",
            behaviour: [
                .eliminated: [
                    .init(
                        name: .discardInPlay,
                        selectors: [
                            .setCard(.allInPlay)
                        ]
                    ),
                    .init(
                        name: .discardHand,
                        selectors: [
                            .setCard(.allInHand)
                        ]
                    )
                ]
            ]
        )
    }

    static var endTurnOnEliminated: Self {
        .init(
            name: .endTurnOnEliminated,
            type: .ability,
            description: "End turn when eliminated",
            behaviour: [
                .eliminated: [
                    .init(
                        name: .startTurn,
                        selectors: [
                            .require(.isCurrentTurn),
                            .setTarget(.nextPlayer)
                        ]
                    )
                ]
            ]
        )
    }

    static var stagecoach: Self {
        .init(
            name: .stagecoach,
            type: .playable,
            description: "Draw two cards from the top of the deck.",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.fixed(2))
                        ]
                    )
                ]
            ]
        )
    }

    static var wellsFargo: Self {
        .init(
            name: .wellsFargo,
            type: .playable,
            description: "Draw three cards from the top of the deck.",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.fixed(3))
                        ]
                    )
                ]
            ]
        )
    }

    static var beer: Self {
        .init(
            name: .beer,
            type: .playable,
            description: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .play,
                        selectors: [.requireThrows(.minimumPlayers(3))]
                    )
                ],
                .cardPlayed: [
                    .init(
                        name: .heal,
                        amount: 1
                    )
                ]
            ]
        )
    }

    static var saloon: Self {
        .init(
            name: .saloon,
            type: .playable,
            description: "All players in play regain one life point.",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .heal,
                        amount: 1,
                        selectors: [
                            .setTarget(.woundedPlayers)
                        ]
                    )
                ]
            ]
        )
    }

    static var catBalou: Self {
        .init(
            name: .catBalou,
            type: .playable,
            description: "Force “any one player” to “discard a card”, regardless of the distance.",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target([.hasCards])),
                            .chooseOne(.targetCard())
                        ]
                    )
                ],
                .cardPlayed: [
                    .init(
                        name: .discardHand,
                        selectors: [
                            .require(.targetedCardFromHand)
                        ]
                    ),
                    .init(
                        name: .discardInPlay,
                        selectors: [
                            .require(.targetedCardFromInPlay)
                        ]
                    )
                ]
            ]
        )
    }

    static var panic: Self {
        .init(
            name: .panic,
            type: .playable,
            description: "Draw a card from a player at distance 1",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target([.atDistance(1), .hasCards])),
                            .chooseOne(.targetCard())
                        ]
                    )
                ],
                .cardPlayed: [
                    .init(
                        name: .stealHand,
                        selectors: [
                            .require(.targetedCardFromHand)
                        ]
                    ),
                    .init(
                        name: .stealInPlay,
                        selectors: [
                            .require(.targetedCardFromInPlay)
                        ]
                    )
                ]
            ]
        )
    }

    static var generalStore: Self {
        .init(
            name: .generalStore,
            type: .playable,
            description: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .discover,
                        selectors: [
                            .repeat(.activePlayerCount)
                        ]
                    ),
                    .init(
                        name: .drawDiscovered,
                        selectors: [
                            .setTarget(.activePlayers),
                            .chooseOne(.discoveredCard)
                        ]
                    )
                ]
            ]
        )
    }

    static var bang: Self {
        .init(
            name: .bang,
            type: .playable,
            description: "reduce other players’s life points",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .play,
                        selectors: [
                            .requireThrows(.playLimitPerTurn([.bang: 1])),
                            .chooseOne(.target([.reachable]))
                        ]
                    )
                ],
                .cardPlayed: [
                    .init(
                        name: .shoot
                    )
                ]
            ]
        )
    }

    static var missed: Self {
        .init(
            name: .missed,
            type: .playable,
            description: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            behaviour: [
                .permanent: [.init(name: .counterShot)]
            ]
        )
    }

    static var gatling: Self {
        .init(
            name: .gatling,
            type: .playable,
            description: "shoots to all the other players, regardless of the distance",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .shoot,
                        selectors: [
                            .setTarget(.otherPlayers)
                        ]
                    )
                ]
            ]
        )
    }

    static var indians: Self {
        .init(
            name: .indians,
            type: .playable,
            description: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            behaviour: [
                .cardPrePlayed: [.play],
                .cardPlayed: [
                    .init(
                        name: .damage,
                        amount: 1,
                        selectors: [
                            .setTarget(.otherPlayers),
                            .chooseOne(.optionalCounterCard([.named(.bang)]))
                        ]
                    )
                ]
            ]
        )
    }

    static var duel: Self {
        .init(
            name: .duel,
            type: .playable,
            description: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target())
                        ]
                    )
                ],
                .cardPlayed: [
                    .init(
                        name: .damage,
                        amount: 1,
                        selectors: [
                            .chooseOne(.optionalRedirectCard([.named(.bang)]))
                        ]
                    )
                ]
            ]
        )
    }

    static var schofield: Self {
        .init(
            name: .schofield,
            type: .playable,
            description: "can hit targets at a distance of 2.",
            behaviour: [
                .cardPrePlayed: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .cardEquiped: [
                    .init(
                        name: .setWeapon,
                        amount: 2
                    )
                ],
                .cardDiscarded: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var remington: Self {
        .init(
            name: .remington,
            type: .playable,
            description: "can hit targets at a distance of 3.",
            behaviour: [
                .cardPrePlayed: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .cardEquiped: [
                    .init(
                        name: .setWeapon,
                        amount: 3
                    )
                ],
                .cardDiscarded: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var revCarabine: Self {
        .init(
            name: .revCarabine,
            type: .playable,
            description: "can hit targets at a distance of 4.",
            behaviour: [
                .cardPrePlayed: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .cardEquiped: [
                    .init(
                        name: .setWeapon,
                        amount: 4
                    )
                ],
                .cardDiscarded: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var winchester: Self {
        .init(
            name: .winchester,
            type: .playable,
            description: "can hit targets at a distance of 5.",
            behaviour: [
                .cardPrePlayed: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .cardEquiped: [
                    .init(
                        name: .setWeapon,
                        amount: 5
                    )
                ],
                .cardDiscarded: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var volcanic: Self {
        .init(
            name: .volcanic,
            type: .playable,
            description: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            behaviour: [
                .cardPrePlayed: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .cardEquiped: [
                    .init(
                        name: .setWeapon,
                        amount: 1
                    ),
                    .init(
                        name: .setPlayLimitPerTurn,
                        amountPerTurn: [.bang: .unlimited]
                    )
                ],
                .cardDiscarded: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var scope: Self {
        .init(
            name: .scope,
            type: .playable,
            description: "you see all the other players at a distance decreased by 1",
            behaviour: [
                .cardPrePlayed: [.equip],
                .cardEquiped: [
                    .init(
                        name: .increaseMagnifying,
                        amount: 1
                    )
                ],
                .cardDiscarded: [
                    .init(
                        name: .increaseMagnifying,
                        amount: -1
                    )
                ]
            ]
        )
    }

    static var mustang: Self {
        .init(
            name: .mustang,
            type: .playable,
            description: "the distance between other players and you is increased by 1",
            behaviour: [
                .cardPrePlayed: [.equip],
                .cardEquiped: [
                    .init(
                        name: .increaseRemoteness,
                        amount: 1
                    )
                ],
                .cardDiscarded: [
                    .init(
                        name: .increaseRemoteness,
                        amount: -1
                    )
                ]
            ]
        )
    }

    static var barrel: Self {
        .init(
            name: .barrel,
            type: .playable,
            description: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            behaviour: [
                .cardPrePlayed: [.equip],
                .shot: [
                    .init(
                        name: .draw,
                        selectors: [
                            .repeat(.drawnCardCount)
                        ]
                    ),
                    .init(
                        name: .counterShot,
                        selectors: [
                            .require(.drawnCardMatches(.regexHearts))
                        ]
                    )
                ],
            ]
        )
    }

    static var dynamite: Self {
        .init(
            name: .dynamite,
            type: .playable,
            description: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            behaviour: [
                .cardPrePlayed: [.equip],
                .turnStarted: [
                    .init(
                        name: .draw,
                        selectors: [
                            .repeat(.drawnCardCount)
                        ]
                    ),
                    .init(name: .passInPlay, selectors: [
                        .require(.drawnCardMatches(.regexPassDynamite)),
                        .setCard(.played),
                        .setTarget(.nextPlayer)
                    ]),
                    .init(
                        name: .damage,
                        amount: 3,
                        selectors: [
                            .require(.drawnCardDoesNotMatch(.regexPassDynamite))
                        ]
                    ),
                    .init(
                        name: .discardInPlay,
                        selectors: [
                            .require(.drawnCardDoesNotMatch(.regexPassDynamite)),
                            .setCard(.played)
                        ]
                    )
                ]
            ]
        )
    }

    static var jail: Self {
        .init(
            name: .jail,
            type: .playable,
            description: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            behaviour: [
                .cardPrePlayed: [
                    .init(
                        name: .handicap,
                        selectors: [
                            .chooseOne(.target())
                        ]
                    )
                ],
                .turnStarted: [
                    .init(
                        name: .draw,
                        selectors: [
                            .repeat(.drawnCardCount)
                        ]
                    ),
                    .init(
                        name: .endTurn,
                        selectors: [
                            .require(.drawnCardDoesNotMatch(.regexHearts))
                        ]
                    ),
                    .init(
                        name: .discardInPlay,
                        selectors: [
                            .setCard(.played)
                        ]
                    )
                ]
            ]
        )
    }

    static var willyTheKid: Self {
        .init(
            name: .willyTheKid,
            type: .character,
            description: "he can play any number of BANG! cards during his turn.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 4
                    ),
                    .init(
                        name: .setPlayLimitPerTurn,
                        amountPerTurn: [.bang: .unlimited]
                    )
                ]
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            name: .roseDoolan,
            type: .character,
            description: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 4
                    ),
                    .init(
                        name: .increaseMagnifying,
                        amount: 1
                    )
                ]
            ]
        )
    }

    static var paulRegret: Self {
        .init(
            name: .paulRegret,
            type: .character,
            description: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 3
                    ),
                    .init(
                        name: .increaseRemoteness,
                        amount: 1
                    )
                ]
            ]
        )
    }

    static var bartCassidy: Self {
        .init(
            name: .bartCassidy,
            type: .character,
            description: "each time he loses a life point, he immediately draws a card from the deck.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 4
                    )
                ],
                .damaged: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.receivedDamageAmount)
                        ]
                    )
                ]
            ]
        )
    }

    static var elGringo: Self {
        .init(
            name: .elGringo,
            type: .character,
            description: "each time he loses a life point due to a card played by another player, he draws a random card from the hands of that player (one card for each life point). If that player has no more cards, too bad! Note that Dynamite damages are not caused by any player.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 3
                    )
                ],
                .damaged: [
                    .init(
                        name: .stealHand,
                        selectors: [
                            .setTarget(.damagingPlayer),
                            .repeat(.receivedDamageAmount),
                            .require(.targetedPlayerHasHandCard),
                            .chooseOne(.targetCard([.isFromHand]))
                        ]
                    )
                ]
            ]
        )
    }

    static var suzyLafayette: Self {
        .init(
            name: .suzyLafayette,
            type: .character,
            description: "as soon as she has no cards in her hand, she draws a card from the draw pile.",
            behaviour: [
                .permanent: [
                    .init(
                        name: .setMaxHealth,
                        amount: 4
                    )
                ],
                .handEmptied: [
                    .init(
                        name: .drawDeck
                    )
                ]
            ]
        )
    }
}

/// Card effect regex
/// https://regex101.com/
private extension String {
    static let regexHearts = "♥️"
    static let regexPassDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
    static let regexRed = "(♥️)|(♦️)"
}

private extension Card.Effect {
    static var play: Self {
        .init(
            name: .play
        )
    }

    static var equip: Self {
        .init(
            name: .equip
        )
    }

    static var resetWeapon: Self {
        .init(
            name: .setWeapon,
            amount: 1
        )
    }

    static var discardEquipedWeapon: Self {
        .init(
            name: .discardInPlay,
            selectors: [
                .setCard(.equippedWeapon)
            ]
        )
    }
}
