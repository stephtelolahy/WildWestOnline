//
//  DefaultAbilities.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 01/12/2024.
//
import GameCore

public enum DefaultAbilities {
    public static let all: [Card] = [
        defaultEndTurn,
        defaultDiscardExcessHandOnTurnEnded,
        defaultDraw2CardsOnTurnStarted,
        defaultStartTurnNextOnTurnEnded,
        defaultEliminateOnDamageLethal,
        defaultEndGameOnEliminated,
        defaultDiscardAllCardsOnEliminated,
        defaultEndTurnOnEliminated
    ]

    public static let allNames: [String] = all.map(\.name)
}

extension DefaultAbilities {
    static var defaultEndTurn: Card {
        .init(
            name: .defaultEndTurn,
            desc: "End turn",
            onPreparePlay: [
                .init(
                    name: .endTurn
                )
            ]
        )
    }

    static var defaultDiscardExcessHandOnTurnEnded: Card {
        .init(
            name: .defaultDiscardExcessHandOnTurnEnded,
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

    static var defaultStartTurnNextOnTurnEnded: Card {
        .init(
            name: .defaultStartTurnNextOnTurnEnded,
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

    static var defaultDraw2CardsOnTurnStarted: Card {
        .init(
            name: .defaultDraw2CardsOnTurnStarted,
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

    static var defaultEliminateOnDamageLethal: Card {
        .init(
            name: .defaultEliminateOnDamageLethal,
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

    static var defaultEndGameOnEliminated: Card {
        .init(
            name: .defaultEndGameOnEliminated,
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

    static var defaultDiscardAllCardsOnEliminated: Card {
        .init(
            name: .defaultDiscardAllCardsOnEliminated,
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

    static var defaultEndTurnOnEliminated: Card {
        .init(
            name: .defaultEndTurnOnEliminated,
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
    static let defaultEndTurn = "defaultEndTurn"
    static let defaultDiscardExcessHandOnTurnEnded = "defaultDiscardExcessHandOnTurnEnded"
    static let defaultDraw2CardsOnTurnStarted = "defaultDraw2CardsOnTurnStarted"
    static let defaultStartTurnNextOnTurnEnded = "defaultStartTurnNextOnTurnEnded"
    static let defaultEliminateOnDamageLethal = "defaultEliminateOnDamageLethal"
    static let defaultEndGameOnEliminated = "defaultEndGameOnEliminated"
    static let defaultDiscardAllCardsOnEliminated = "defaultDiscardAllCardsOnEliminated"
    static let defaultEndTurnOnEliminated = "defaultEndTurnOnEliminated"
    static let defaultDiscardBeerOnDamagedLethal = "defaultDiscardBeerOnDamagedLethal"
}
