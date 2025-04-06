//
//  Collectibles.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 06/04/2025.
//

import GameCore

enum Collectibles {
    static let all: [Card] = [
        stagecoach,
        wellsFargo,
        beer,
        saloon,
        catBalou,
        panic,
        generalStore,
        bang,
        gatling,
        missed,
        indians,
        duel,
        schofield,
        remington,
        revCarabine,
        winchester,
        volcanic,
        scope,
        mustang,
        barrel,
        dynamite,
        jail,
    ]
}

private extension Collectibles {
    static var stagecoach: Card {
        .init(
            name: .stagecoach,
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

    static var wellsFargo: Card {
        .init(
            name: .wellsFargo,
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

    static var beer: Card {
        .init(
            name: .beer,
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

    static var saloon: Card {
        .init(
            name: .saloon,
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

    static var catBalou: Card {
        .init(
            name: .catBalou,
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

    static var panic: Card {
        .init(
            name: .panic,
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

    static var generalStore: Card {
        .init(
            name: .generalStore,
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

    static var bang: Card {
        .init(
            name: .bang,
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

    static var gatling: Card {
        .init(
            name: .gatling,
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

    static var missed: Card {
        .init(
            name: .missed,
            desc: "If you are hit by a BANG! you may immediately play a Missed! - even though it is not your turn! - to cancel the shot.",
            canCounterShot: true
        )
    }

    static var indians: Card {
        .init(
            name: .indians,
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

    static var duel: Card {
        .init(
            name: .duel,
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

    static var schofield: Card {
        .init(
            name: .schofield,
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

    static var remington: Card {
        .init(
            name: .remington,
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

    static var revCarabine: Card {
        .init(
            name: .revCarabine,
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

    static var winchester: Card {
        .init(
            name: .winchester,
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

    static var volcanic: Card {
        .init(
            name: .volcanic,
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

    static var scope: Card {
        .init(
            name: .scope,
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

    static var mustang: Card {
        .init(
            name: .mustang,
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

    static var barrel: Card {
        .init(
            name: .barrel,
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

    static var dynamite: Card {
        .init(
            name: .dynamite,
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

    static var jail: Card {
        .init(
            name: .jail,
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
}


/// Card effect regex
/// https://regex101.com/
private extension String {
    static let regexHearts = "♥️"
    static let regexPassDynamite = "(♥️)|(♦️)|(♣️)|([10|J|Q|K|A]♠️)"
    static let regexRed = "(♥️)|(♦️)"
}

public extension Int {
    static let infinity = 999
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

public extension String {
    static let bang = "bang"
    static let missed = "missed"
    static let beer = "beer"
    static let saloon = "saloon"
    static let stagecoach = "stagecoach"
    static let wellsFargo = "wellsFargo"
    static let generalStore = "generalStore"
    static let catBalou = "catBalou"
    static let panic = "panic"
    static let gatling = "gatling"
    static let indians = "indians"
    static let duel = "duel"
    static let barrel = "barrel"
    static let dynamite = "dynamite"
    static let jail = "jail"
    static let schofield = "schofield"
    static let remington = "remington"
    static let revCarabine = "revCarabine"
    static let winchester = "winchester"
    static let volcanic = "volcanic"
    static let scope = "scope"
    static let mustang = "mustang"
    static let punch = "punch"
    static let dodge = "dodge"
    static let springfield = "springfield"
    static let hideout = "hideout"
    static let binocular = "binocular"
    static let whisky = "whisky"
    static let tequila = "tequila"
    static let ragTime = "ragTime"
    static let brawl = "brawl"
    static let lastCall = "lastCall"
    static let tornado = "tornado"
    static let backfire = "backfire"
    static let tomahawk = "tomahawk"
    static let aim = "aim"
    static let faning = "faning"
    static let saved = "saved"
    static let bandidos = "bandidos"
    static let poker = "poker"
    static let lemat = "lemat"
    static let shootgun = "shootgun"
    static let bounty = "bounty"
    static let rattlesnake = "rattlesnake"
    static let escape = "escape"
    static let ghost = "ghost"
}


