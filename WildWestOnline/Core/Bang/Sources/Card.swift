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
            .discardSilently,
            .heal_1
        ],
        "saloon": [
            .discardSilently,
            .heal_1_all
        ],
        "stagecoach": [
            .discardSilently,
            .drawDeck_2
        ],
        "wellsFargo": [
            .discardSilently,
            .drawDeck_3
        ],
        "catBalou": [
            .discardSilently,
            .discard_any
        ],
        "panic": [
            .discardSilently,
            .steal_any_atDistanceOf1
        ],
        "bang": [
            .discardSilently,
            .shoot_any_reachable
        ],
        "missed": [
            .discardSilently,
            .missed
        ],
        "gatling": [
            .discardSilently,
            .shoot_others
        ],
        "indians": [
            .discardSilently,
            .damage_others_counterWithBang
        ],
        "duel": [
            .discardSilently,
            .damage_any_reverseWithBang
        ],
        "generalStore": [
            .discardSilently,
            .reveal_numberOfPlayers,
            .chooseCard_all
        ],
        "barrel": [
            .equip,
            .draw_onShot,
            .missed_onShot
        ],
        "dynamite": [
            .equip,
            .draw_onTurnStarted,
            .passInPlay_onTurnStarted,
            .damage_3_onTurnStarted,
            .discard_onTurnStarted_ifDrawSpades
        ],
        "schofield": [
            .equip,
            .weapon_2
        ],
        "remington": [
            .equip,
            .weapon_3
        ],
        "revCarabine": [
            .equip,
            .weapon_4
        ],
        "winchester": [
            .equip,
            .weapon_5
        ],
        "volcanic": [
            .equip,
            .weapon_1,
            .setUnlimitedBang
        ],
        "scope": [
            .equip,
            .increaseMagnifying
        ],
        "mustang": [
            .equip,
            .increaseRemoteness
        ],
        "jail": [
            .handicap,
            .draw_onTurnStarted,
            .endTurn_onTurnStarted,
            .discard_onTurnStarted
        ],
        "endTurn": [
            .endTurn,
            .discard_excessHand
        ],
        "default": [
            .startTurn_next_onTurnEnded,
            .drawDeck_onTurnStarted,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
        ]
    ]
}
