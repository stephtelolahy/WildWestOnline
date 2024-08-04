// The Swift Programming Language
// https://docs.swift.org/swift-book

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
///
typealias Card = [CardEffect]

public enum Cards {
    static let all: [String: Card] = [
        "beer": [
            .discardOnPlayed,
            .heal1
        ],
        "saloon": [
            .discardOnPlayed,
            .heal1All
        ],
        "stagecoach": [
            .discardOnPlayed,
            .draw2Cards
        ],
        "wellsFargo": [
            .discardOnPlayed,
            .draw3Cards
        ],
        "catBalou": [
            .discardOnPlayed,
            .discardAnyOther
        ],
        "panic": [
            .discardOnPlayed,
            .stealAnyOtherAtDistanceOf1
        ],
        "bang": [
            .discardOnPlayed,
            .shootAnyReachable
        ],
        "missed": [
            .discardOnPlayed,
            .counterShoot
        ],
        "gatling": [
            .discardOnPlayed,
            .shootOthers
        ],
        "indians": [
            .discardOnPlayed,
            .damageOthersCounterWithBang
        ],
        "duel": [
            .discardOnPlayed,
            .damageAnyReverseWithBang
        ],
        "generalStore": [
            .discardOnPlayed,
            .revealCardsAsNumberOfPlayers,
            .chooseCardAll
        ],
        "barrel": [
            .equipment,
            .drawOnShot,
            .counterShootIfDrawHearts
        ],
        "dynamite": [
            .equipment,
            .drawOnTurnStarted,
            .passInPlayIfNotDrawSpades,
            .damage3IfDrawSpades,
            .discardIfDrawSpades
        ],
        "schofield": [
            .equipment,
            .weapon2
        ],
        "remington": [
            .equipment,
            .weapon3
        ],
        "revCarabine": [
            .equipment,
            .weapon4
        ],
        "winchester": [
            .equipment,
            .weapon5
        ],
        "volcanic": [
            .equipment,
            .weapon1,
            .unlimitedBang
        ],
        "scope": [
            .equipment,
            .increaseMagnifying
        ],
        "mustang": [
            .equipment,
            .increaseRemoteness
        ],
        "jail": [
            .handicap,
            .drawOnTurnStarted,
            .skipTurnIfNotDrawHearts,
            .discardOnTurnStarted
        ],
        "endTurn": [
            .endTurn,
            .discardExcessHand,
            .startTurnNext
        ],
        "onStartTurn": [
            .drawOnStartTurn
        ],
        "onDamageLethal": [
            .eliminateOnDamageLethal
        ],
        "onEliminated": [
            .nextTurnOnEliminated,
            .discardAllCardsOnEliminated
        ]
    ]
}
