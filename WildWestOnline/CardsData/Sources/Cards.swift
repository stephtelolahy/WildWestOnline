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
        .gatling,
        .missed,
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
    ].reduce(into: [:]) { result, card in
        result[card.name] = card
    }
}

private extension Card {
    static var endTurn: Self {
        .init(
            name: .endTurn,
            type: .ability,
            desc: "End turn",
            onPreparePlay: [
                .init(
                    name: .endTurn
                )
            ]
        )
    }

    static var discardExcessHandOnTurnEnded: Self {
        .init(
            name: .discardExcessHandOnTurnEnded,
            type: .ability,
            desc: "Once you do not want to or cannot play any more cards, then you must discard from your hand any cards exceeding your hand-size limit",
            canTrigger: [
                .init(actionName: .endTurn)
            ],
            onTrigger: [
                .init(
                    name: .discardHand,
                    selectors: [
                        .repeat(.excessHand),
                        .chooseOne(.card([.fromHand]))
                    ]
                )
            ]
        )
    }

    static var startTurnNextOnTurnEnded: Self {
        .init(
            name: .startTurnNextOnTurnEnded,
            type: .ability,
            desc: "Start next player's turn",
            canTrigger: [
                .init(actionName: .endTurn)
            ],
            onTrigger: [
                .init(
                    name: .startTurn,
                    selectors: [
                        .setTarget(.next)
                    ]
                )
            ]
        )
    }

    static var draw2CardsOnTurnStarted: Self {
        .init(
            name: .draw2CardsOnTurnStarted,
            type: .ability,
            desc: "Draw two cards at the beginning of your turn",
            canTrigger: [
                .init(actionName: .startTurn)
            ],
            onTrigger: [
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var eliminateOnDamageLethal: Self {
        .init(
            name: .eliminateOnDamageLethal,
            type: .ability,
            desc: "When you lose your last life point, you are eliminated and your game is over",
            canTrigger: [
                .init(
                    actionName: .damage,
                    stateReqs: [.healthZero]
                )
            ],
            onTrigger: [
                .init(name: .eliminate)
            ]
        )
    }

    static var endGameOnEliminated: Self {
        .init(
            name: .endGameOnEliminated,
            type: .ability,
            desc: "End game when last player is eliminated",
            canTrigger: [
                .init(
                    actionName: .eliminate,
                    stateReqs: [.gameOver]
                )
            ],
            onTrigger: [
                .init(name: .endGame)
            ]
        )
    }

    static var discardAllCardsOnEliminated: Self {
        .init(
            name: .discardAllCardsOnEliminated,
            type: .ability,
            desc: "Discard all cards when eliminated",
            canTrigger: [
                .init(actionName: .eliminate)
            ],
            onTrigger: [
                .init(
                    name: .discardInPlay,
                    selectors: [
                        .setCard(.allInPlay)
                    ]
                ),
                .init(
                    name: .discardHand,
                    selectors: [
                        .setCard(.allHand)
                    ]
                )
            ]
        )
    }

    static var endTurnOnEliminated: Self {
        .init(
            name: .endTurnOnEliminated,
            type: .ability,
            desc: "End turn when eliminated",
            canTrigger: [
                .init(
                    actionName: .eliminate,
                    stateReqs: [.currentTurn]
                )
            ],
            onTrigger: [
                .init(
                    name: .startTurn,
                    selectors: [
                        .setTarget(.next)
                    ]
                )
            ]
        )
    }

    static var stagecoach: Self {
        .init(
            name: .stagecoach,
            type: .brown,
            desc: "Draw two cards from the top of the deck.",
            onPreparePlay: [
                .play,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var wellsFargo: Self {
        .init(
            name: .wellsFargo,
            type: .brown,
            desc: "Draw three cards from the top of the deck.",
            onPreparePlay: [
                .play,
                .init(
                    name: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ]
                )
            ]
        )
    }

    static var beer: Self {
        .init(
            name: .beer,
            type: .brown,
            desc: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            canPlay: [
                .playersAtLeast(3)
            ],
            onPreparePlay: [
                .play,
                .init(
                    name: .heal,
                    payload: .init(amount: 1)
                )
            ]
        )
    }

    static var saloon: Self {
        .init(
            name: .saloon,
            type: .brown,
            desc: "All players in play regain one life point.",
            onPreparePlay: [
                .play,
                .init(
                    name: .heal,
                    payload: .init(amount: 1),
                    selectors: [
                        .setTarget(.damaged)
                    ]
                )
            ]
        )
    }

    static var catBalou: Self {
        .init(
            name: .catBalou,
            type: .brown,
            desc: "Force “any one player” to “discard a card”, regardless of the distance.",
            onPreparePlay: [
                .init(
                    name: .play,
                    selectors: [
                        .chooseOne(.target([.havingCard])),
                        .chooseOne(.card())
                    ]
                )
            ],
            onPlay: [
                .init(
                    name: .discardHand,
                    selectors: [
                        .require(.payloadCardIsFromTargetHand)
                    ]
                ),
                .init(
                    name: .discardInPlay,
                    selectors: [
                        .require(.payloadCardIsFromTargetInPlay)
                    ]
                )
            ]
        )
    }

    static var panic: Self {
        .init(
            name: .panic,
            type: .brown,
            desc: "Draw a card from a player at distance 1",
            onPreparePlay: [
                .init(
                    name: .play,
                    selectors: [
                        .chooseOne(.target([.atDistance(1), .havingCard])),
                        .chooseOne(.card())
                    ]
                )
            ],
            onPlay: [
                .init(
                    name: .stealHand,
                    selectors: [
                        .require(.payloadCardIsFromTargetHand)
                    ]
                ),
                .init(
                    name: .stealInPlay,
                    selectors: [
                        .require(.payloadCardIsFromTargetInPlay)
                    ]
                )
            ]
        )
    }

    static var generalStore: Self {
        .init(
            name: .generalStore,
            type: .brown,
            desc: "When you play this card, turn as many cards from the deck face up as the players still playing. Starting with you and proceeding clockwise, each player chooses one of those cards and puts it in his hands.",
            onPreparePlay: [
                .play,
                .init(
                    name: .discover,
                    selectors: [
                        .repeat(.activePlayers)
                    ]
                ),
                .init(
                    name: .drawDiscovered,
                    selectors: [
                        .setTarget(.active),
                        .chooseOne(.discovered)
                    ]
                )
            ]
        )
    }

    static var bang: Self {
        .init(
            name: .bang,
            type: .brown,
            desc: "reduce other players’s life points",
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

    static var gatling: Self {
        .init(
            name: .gatling,
            type: .brown,
            desc: "shoots to all the other players, regardless of the distance",
            onPreparePlay: [
                .play,
                .init(
                    name: .shoot,
                    selectors: [
                        .setTarget(.others)
                    ]
                )
            ]
        )
    }

    static var missed: Self {
        .init(
            name: .missed,
            type: .brown,
            desc: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            canCounterShot: true
        )
    }

    static var indians: Self {
        .init(
            name: .indians,
            type: .brown,
            desc: "Each player, excluding the one who played this card, may discard a BANG! card, or lose one life point.",
            onPreparePlay: [
                .play,
                .init(
                    name: .damage,
                    payload: .init(amount: 1),
                    selectors: [
                        .setTarget(.others),
                        .chooseOne(.eventuallyCounterCard([.named(.bang)]))
                    ]
                )
            ]
        )
    }

    static var duel: Self {
        .init(
            name: .duel,
            type: .brown,
            desc: "can challenge any other player. The first player failing to discard a BANG! card loses one life point.",
            onPreparePlay: [
                .init(
                    name: .play,
                    selectors: [
                        .chooseOne(.target())
                    ]
                )
            ],
            onPlay: [
                .init(
                    name: .damage,
                    payload: .init(amount: 1),
                    selectors: [
                        .chooseOne(.eventuallyReverseCard([.named(.bang)]))
                    ]
                )
            ]
        )
    }

    static var schofield: Self {
        .init(
            name: .schofield,
            type: .blue,
            desc: "can hit targets at a distance of 2.",
            onPreparePlay: [
                .discardEquipedWeapon,
                .equip
            ],
            onActive: [
                .init(
                    name: .setWeapon,
                    payload: .init(amount: 2)
                )
            ],
            onDeactive: [.resetWeapon]
        )
    }

    static var remington: Self {
        .init(
            name: .remington,
            type: .blue,
            desc: "can hit targets at a distance of 3.",
            onPreparePlay: [
                .discardEquipedWeapon,
                .equip
            ],
            onActive: [
                .init(
                    name: .setWeapon,
                    payload: .init(amount: 3)
                )
            ],
            onDeactive: [.resetWeapon]
        )
    }

    static var revCarabine: Self {
        .init(
            name: .revCarabine,
            type: .blue,
            desc: "can hit targets at a distance of 4.",
            onPreparePlay: [
                .discardEquipedWeapon,
                .equip
            ],
            onActive: [
                .init(
                    name: .setWeapon,
                    payload: .init(amount: 4)
                )
            ],
            onDeactive: [.resetWeapon]
        )
    }

    static var winchester: Self {
        .init(
            name: .winchester,
            type: .blue,
            desc: "can hit targets at a distance of 5.",
            onPreparePlay: [
                .discardEquipedWeapon,
                .equip
            ],
            onActive: [
                .init(
                    name: .setWeapon,
                    payload: .init(amount: 5)
                )
            ],
            onDeactive: [.resetWeapon]
        )
    }

    static var volcanic: Self {
        .init(
            name: .volcanic,
            type: .blue,
            desc: "can play any number of BANG! cards during your turn but limited to a distance of 1",
            onPreparePlay: [
                .discardEquipedWeapon,
                .equip
            ],
            onActive: [
                .init(
                    name: .setWeapon,
                    payload: .init(amount: 1)
                ),
                .init(
                    name: .setPlayLimitPerTurn,
                    payload: .init(amountPerTurn: [.bang: .infinity])
                )
            ],
            onDeactive: [.resetWeapon]
        )
    }

    static var scope: Self {
        .init(
            name: .scope,
            type: .blue,
            desc: "you see all the other players at a distance decreased by 1",
            onPreparePlay: [.equip],
            onActive: [
                .init(
                    name: .increaseMagnifying,
                    payload: .init(amount: 1)
                )
            ],
            onDeactive: [
                .init(
                    name: .increaseMagnifying,
                    payload: .init(amount: -1)
                )
            ]
        )
    }

    static var mustang: Self {
        .init(
            name: .mustang,
            type: .blue,
            desc: "the distance between other players and you is increased by 1",
            onPreparePlay: [.equip],
            onActive: [
                .init(
                    name: .increaseRemoteness,
                    payload: .init(amount: 1)
                )
            ],
            onDeactive: [
                .init(
                    name: .increaseRemoteness,
                    payload: .init(amount: -1)
                )
            ]
        )
    }

    static var barrel: Self {
        .init(
            name: .barrel,
            type: .blue,
            desc: "allows you to “draw!” when you are the target of a BANG!: - if you draw a Heart card, you are Missed! (just like if you played a Missed! card); - otherwise nothing happens.",
            onPreparePlay: [.equip],
            canTrigger: [
                .init(actionName: .shoot)
            ],
            onTrigger: [
                .init(
                    name: .draw,
                    selectors: [
                        .repeat(.drawCards)
                    ]
                ),
                .init(
                    name: .counterShot,
                    selectors: [
                        .require(.drawMatching(.regexHearts))
                    ]
                )
            ]
        )
    }

    static var dynamite: Self {
        .init(
            name: .dynamite,
            type: .blue,
            desc: "Play this card in front of you: the Dynamite will stay there for a whole turn. When you start your next turn (you have the Dynamite already in play), before the first phase you must “draw!”: - if you draw a card showing Spades and a number between 2 and 9, the Dynamite explodes! Discard it and lose 3 life points; - otherwise, pass the Dynamite to the player on your left (who will “draw!” on his turn, etc.).",
            onPreparePlay: [.equip],
            canTrigger: [
                .init(actionName: .startTurn)
            ],
            onTrigger: [
                .init(
                    name: .draw,
                    selectors: [
                        .repeat(.drawCards)
                    ]
                ),
                .init(name: .passInPlay, selectors: [
                    .require(.drawMatching(.regexPassDynamite)),
                    .setCard(.played),
                    .setTarget(.next)
                ]),
                .init(
                    name: .damage,
                    payload: .init(amount: 3),
                    selectors: [
                        .require(.drawNotMatching(.regexPassDynamite))
                    ]
                ),
                .init(
                    name: .discardInPlay,
                    selectors: [
                        .require(.drawNotMatching(.regexPassDynamite)),
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
            desc: "Play this card in front of any player regardless of the distance: you put him in jail! If you are in jail, you must “draw!” before the beginning of your turn: - if you draw a Heart card, you escape from jail: discard the Jail, and continue your turn as normal; - otherwise discard the Jail and skip your turn",
            onPreparePlay: [
                .init(
                    name: .handicap,
                    selectors: [
                        .chooseOne(.target())
                    ]
                )
            ],
            canTrigger: [
                .init(actionName: .startTurn)
            ],
            onTrigger: [
                .init(
                    name: .draw,
                    selectors: [
                        .repeat(.drawCards)
                    ]
                ),
                .init(
                    name: .endTurn,
                    selectors: [
                        .require(.drawNotMatching(.regexHearts))
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
            desc: "he can play any number of BANG! cards during his turn.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 4)
                ),
                .init(
                    name: .setPlayLimitPerTurn,
                    payload: .init(amountPerTurn: [.bang: .infinity])
                )
            ]
        )
    }

    static var roseDoolan: Self {
        .init(
            name: .roseDoolan,
            type: .character,
            desc: "she is considered to have an Appaloosa card in play at all times; she sees the other players at a distance decreased by 1.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 4)
                ),
                .init(
                    name: .increaseMagnifying,
                    payload: .init(amount: 1)
                )
            ]
        )
    }

    static var paulRegret: Self {
        .init(
            name: .paulRegret,
            type: .character,
            desc: "he is considered to have a Mustang card in play at all times; all other players must add 1 to the distance to him.",
            onActive: [
                .init(
                    name: .setMaxHealth,
                    payload: .init(amount: 3)
                ),
                .init(
                    name: .increaseRemoteness,
                    payload: .init(amount: 1)
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
            payload: .init(amount: 1)
        )
    }

    static var discardEquipedWeapon: Self {
        .init(
            name: .discardInPlay,
            selectors: [
                .setCard(.weaponInPlay)
            ]
        )
    }
}
