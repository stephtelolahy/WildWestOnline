//
//  PlayerAbilities.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 01/12/2024.
//
import GameCore

public enum PlayerAbilities {
    public static let all: [Card] = [
        endTurn,
        discardExcessHandOnTurnEnded,
        draw2CardsOnTurnStarted,
        startTurnNextOnTurnEnded,
        eliminateOnDamageLethal,
        endGameOnEliminated,
        discardAllCardsOnEliminated,
        endTurnOnEliminated
    ]

    public static let allNames: [String] = all.map(\.name)
}

extension PlayerAbilities {
    static var endTurn: Card {
        .init(
            name: .endTurn,
            desc: "End turn",
            onPreparePlay: [
                .init(
                    name: .endTurn
                )
            ]
        )
    }

    static var discardExcessHandOnTurnEnded: Card {
        .init(
            name: .discardExcessHandOnTurnEnded,
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

    static var startTurnNextOnTurnEnded: Card {
        .init(
            name: .startTurnNextOnTurnEnded,
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

    static var draw2CardsOnTurnStarted: Card {
        .init(
            name: .draw2CardsOnTurnStarted,
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

    static var eliminateOnDamageLethal: Card {
        .init(
            name: .eliminateOnDamageLethal,
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

    static var endGameOnEliminated: Card {
        .init(
            name: .endGameOnEliminated,
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

    static var discardAllCardsOnEliminated: Card {
        .init(
            name: .discardAllCardsOnEliminated,
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

    static var endTurnOnEliminated: Card {
        .init(
            name: .endTurnOnEliminated,
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
}

public extension String {
    static let endTurn = "endTurn"
    static let discardExcessHandOnTurnEnded = "discardExcessHandOnTurnEnded"
    static let draw2CardsOnTurnStarted = "draw2CardsOnTurnStarted"
    static let startTurnNextOnTurnEnded = "startTurnNextOnTurnEnded"
    static let eliminateOnDamageLethal = "eliminateOnDamageLethal"
    static let endGameOnEliminated = "endGameOnEliminated"
    static let discardAllCardsOnEliminated = "discardAllCardsOnEliminated"
    static let endTurnOnEliminated = "endTurnOnEliminated"
    static let discardBeerOnDamagedLethal = "discardBeerOnDamagedLethal"
}
