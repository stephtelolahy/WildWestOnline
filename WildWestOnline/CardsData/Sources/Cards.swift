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
    public static let all: [String: Card] = [
        .endTurn,
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
    ]
        .reduce(into: [:]) { result, card in
            result[card.name] = card
        }
}

private extension Card {
    static var endTurn: Self {
        .init(
            name: .endTurn,
            type: .ability,
            description: "End turn",
            behaviour: [
                .preparePlay: [.init(name: .endTurn)]
            ]
        )
    }

    static var discardExcessHandOnTurnEnded: Self {
        .init(
            name: .discardExcessHandOnTurnEnded,
            type: .ability,
            description: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            behaviour: [
                .endTurn: [
                    .init(
                        name: .discardHand,
                        selectors: [
                            .repeat(.playerExcessHandSize),
                            .chooseOne(.targetCard([.isFromHand]))
                        ]
                    )
                ]
            ]
        )
    }

    static var startTurnNextOnTurnEnded: Self {
        .init(
            name: .startTurnNextOnTurnEnded,
            type: .ability,
            description: "Start next player's turn",
            behaviour: [
                .endTurn: [
                    .init(
                        name: .startTurn,
                        selectors: [
                            .setTarget(.nextPlayer)
                        ]
                    )
                ]
            ]
        )
    }

    static var draw2CardsOnTurnStarted: Self {
        .init(
            name: .draw2CardsOnTurnStarted,
            type: .ability,
            description: "Draw two cards at the beginning of your turn",
            behaviour: [
                .startTurn: [
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
                .damage: [
                    .init(
                        name: .eliminate,
                        selectors: [.require(.isHealthZero)]
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
                .eliminate: [
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
                .eliminate: [
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
                .eliminate: [
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
            type: .brown,
            description: "Draw two cards from the top of the deck.",
            behaviour: [
                .preparePlay: [.play],
                .play: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.fixed(2)),
                            .setTarget(.currentPlayer)
                        ]
                    )
                ]
            ]
        )
    }

    static var wellsFargo: Self {
        .init(
            name: .wellsFargo,
            type: .brown,
            description: "Draw three cards from the top of the deck.",
            behaviour: [
                .preparePlay: [.play],
                .play: [
                    .init(
                        name: .drawDeck,
                        selectors: [
                            .repeat(.fixed(3)),
                            .setTarget(.currentPlayer)
                        ]
                    )
                ]
            ]
        )
    }

    static var beer: Self {
        .init(
            name: .beer,
            type: .brown,
            description: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            behaviour: [
                .preparePlay: [
                    .init(
                        name: .play,
                        selectors: [.requireThrows(.minimumPlayers(3))]
                    )
                ],
                .play: [
                    .init(
                        name: .heal,
                        amount: 1,
                        selectors: [
                            .setTarget(.currentPlayer)
                        ]
                    )
                ]
            ]
        )
    }

    static var saloon: Self {
        .init(
            name: .saloon,
            type: .brown,
            description: "All players in play regain one life point.",
            behaviour: [
                .preparePlay: [.play],
                .play: [
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
            type: .brown,
            description: "Force “any one player” to “discard a card”, regardless of the distance.",
            behaviour: [
                .preparePlay: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target([.hasCards])),
                            .chooseOne(.targetCard())
                        ]
                    )
                ],
                .play: [
                    .init(
                        name: .discardHand,
                        selectors: [
                            .require(.payloadCardFromTargetHand)
                        ]
                    ),
                    .init(
                        name: .discardInPlay,
                        selectors: [
                            .require(.payloadCardFromTargetInPlay)
                        ]
                    )
                ]
            ]
        )
    }

    static var panic: Self {
        .init(
            name: .panic,
            type: .brown,
            description: "Draw a card from a player at distance 1",
            behaviour: [
                .preparePlay: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target([.atDistance(1), .hasCards])),
                            .chooseOne(.targetCard())
                        ]
                    )
                ],
                .play: [
                    .init(
                        name: .stealHand,
                        selectors: [
                            .require(.payloadCardFromTargetHand)
                        ]
                    ),
                    .init(
                        name: .stealInPlay,
                        selectors: [
                            .require(.payloadCardFromTargetInPlay)
                        ]
                    )
                ]
            ]
        )
    }

    static var generalStore: Self {
        .init(
            name: .generalStore,
            type: .brown,
            description: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            behaviour: [
                .preparePlay: [.play],
                .play: [
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
            type: .brown,
            description: "reduce other players’s life points",
            /*
             behaviour: [
                 .preparePlay: [
                     .init(
                         name: .play,
                         selectors: [
                             .requireThrows(.playLimitPerTurn([.bang: 1])),
                             .chooseOne(.target([.reachable]))
                         ]
                     )
                 ],
                 .play: [
                     .init(
                         name: .shoot
                     )
                 ]
             ]
             */
            canPlay: [
                .playLimitPerTurn([.bang: 1])
            ],
            onPreparePlay: [
                .init(
                    name: .play,
                    selectors: [
                        .chooseOne(.target([.reachable]))
                    ]
                )
            ],
            onPlay: [
                .init(
                    name: .shoot
                )
            ]
        )
    }

    static var missed: Self {
        .init(
            name: .missed,
            type: .brown,
            description: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            canCounterShot: true
        )
    }

    static var gatling: Self {
        .init(
            name: .gatling,
            type: .brown,
            description: "shoots to all the other players, regardless of the distance",
            behaviour: [
                .preparePlay: [.play],
                .play: [
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
            type: .brown,
            description: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            behaviour: [
                .preparePlay: [.play],
                .play: [
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
            type: .brown,
            description: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            behaviour: [
                .preparePlay: [
                    .init(
                        name: .play,
                        selectors: [
                            .chooseOne(.target())
                        ]
                    )
                ],
                .play: [
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
            type: .blue,
            description: "can hit targets at a distance of 2.",
            behaviour: [
                .preparePlay: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .equip: [
                    .init(
                        name: .setWeapon,
                        amount: 2
                    )
                ],
                .discardInPlay: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var remington: Self {
        .init(
            name: .remington,
            type: .blue,
            description: "can hit targets at a distance of 3.",
            behaviour: [
                .preparePlay: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .equip: [
                    .init(
                        name: .setWeapon,
                        amount: 3
                    )
                ],
                .discardInPlay: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var revCarabine: Self {
        .init(
            name: .revCarabine,
            type: .blue,
            description: "can hit targets at a distance of 4.",
            behaviour: [
                .preparePlay: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .equip: [
                    .init(
                        name: .setWeapon,
                        amount: 4
                    )
                ],
                .discardInPlay: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var winchester: Self {
        .init(
            name: .winchester,
            type: .blue,
            description: "can hit targets at a distance of 5.",
            behaviour: [
                .preparePlay: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .equip: [
                    .init(
                        name: .setWeapon,
                        amount: 5
                    )
                ],
                .discardInPlay: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var volcanic: Self {
        .init(
            name: .volcanic,
            type: .blue,
            description: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            behaviour: [
                .preparePlay: [
                    .discardEquipedWeapon,
                    .equip
                ],
                .equip: [
                    .init(
                        name: .setWeapon,
                        amount: 1
                    ),
                    .init(
                        name: .setPlayLimitPerTurn,
                        amountPerTurn: [.bang: .unlimited]
                    )
                ],
                .discardInPlay: [
                    .resetWeapon
                ]
            ]
        )
    }

    static var scope: Self {
        .init(
            name: .scope,
            type: .blue,
            description: "you see all the other players at a distance decreased by 1",
            onPreparePlay: [.equip],
            onActive: [
                .init(
                    name: .increaseMagnifying,
                    amount: 1
                )
            ],
            onInactive: [
                .init(
                    name: .increaseMagnifying,
                    amount: -1
                )
            ]
        )
    }

    static var mustang: Self {
        .init(
            name: .mustang,
            type: .blue,
            description: "the distance between other players and you is increased by 1",
            onPreparePlay: [.equip],
            onActive: [
                .init(
                    name: .increaseRemoteness,
                    amount: 1
                )
            ],
            onInactive: [
                .init(
                    name: .increaseRemoteness,
                    amount: -1
                )
            ]
        )
    }

    static var barrel: Self {
        .init(
            name: .barrel,
            type: .blue,
            description: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            onPreparePlay: [.equip],
            canTrigger: [
                .init(name: .shoot)
            ],
            onTrigger: [
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
            ]
        )
    }

    static var dynamite: Self {
        .init(
            name: .dynamite,
            type: .blue,
            description: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            onPreparePlay: [.equip],
            canTrigger: [
                .init(name: .startTurn)
            ],
            onTrigger: [
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
        )
    }

    static var jail: Self {
        .init(
            name: .jail,
            type: .blue,
            description: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            onPreparePlay: [
                .init(
                    name: .handicap,
                    selectors: [
                        .chooseOne(.target())
                    ]
                )
            ],
            canTrigger: [
                .init(name: .startTurn)
            ],
            onTrigger: [
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
        )
    }

    static var willyTheKid: Self {
        .init(
            name: .willyTheKid,
            type: .character,
            description: "he can play any number of BANG! cards during his turn.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    amount: 4
                ),
                .init(
                    name: .setPlayLimitPerTurn,
                    amountPerTurn: [.bang: .unlimited]
                )
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            name: .roseDoolan,
            type: .character,
            description: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    amount: 4
                ),
                .init(
                    name: .increaseMagnifying,
                    amount: 1
                )
            ]
        )
    }

    static var paulRegret: Self {
        .init(
            name: .paulRegret,
            type: .character,
            description: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    amount: 3
                ),
                .init(
                    name: .increaseRemoteness,
                    amount: 1
                )
            ]
        )
    }

    static var bartCassidy: Self {
        .init(
            name: .bartCassidy,
            type: .character,
            description: "each time he loses a life point, he immediately draws a card from the deck.",
            canTrigger: [
                .init(
                    name: .damage,
                    conditions: [.isHealthNonZero]
                )
            ],
            onTrigger: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.receivedDamageAmount)
                    ]
                )
            ],
            onActive: [
                .init(
                    name: .setMaxHealth,
                    amount: 4
                )
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
