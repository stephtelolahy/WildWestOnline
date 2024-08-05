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
            .heal_1_ifPlayersAtLeast3
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
            .reveal_activePlayers,
            .chooseCard_all
        ],
        "barrel": [
            .equip,
            .draw_onShot,
            .missed_onShot_ifDrawHearts
        ],
        "dynamite": [
            .equip,
            .draw_onTurnStarted,
            .pass_next_onTurnStarted_ifNotDrawSpades,
            .damage_3_onTurnStarted_ifDrawSpades,
            .discard_onTurnStarted_ifDrawSpades
        ],
        "schofield": [
            .equip,
            .setWeapon_2
        ],
        "remington": [
            .equip,
            .setWeapon_3
        ],
        "revCarabine": [
            .equip,
            .setWeapon_4
        ],
        "winchester": [
            .equip,
            .setWeapon_5
        ],
        "volcanic": [
            .equip,
            .setWeapon_1,
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
            .endTurn_onTurnStarted_ifNotDrawHearts,
            .discard_onTurnStarted
        ],
        "endTurn": [
            .endTurn,
            .discard_excessHand
        ],
        "default": [
            .startTurn_next_onTurnEnded,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
            .discard_previousWeapon_onWeaponPlayed,
            .play_missed_onShot,
            .play_beer_onDamagedLethal
        ],
        "willyTheKid": [
            .setUnlimitedBang,
            .drawDeck_startTurnCards_onTurnStarted
        ],
        "roseDoolan": [
            .increaseMagnifying,
            .drawDeck_startTurnCards_onTurnStarted
        ],
        "paulRegret": [
            .increaseRemoteness,
            .drawDeck_startTurnCards_onTurnStarted
        ],
        "jourdonnais": [
            .draw_onShot,
            .missed_onShot_ifDrawHearts,
            .drawDeck_startTurnCards_onTurnStarted
        ],
        "bartCassidy": [
            .drawDeck_onDamaged,
            .drawDeck_startTurnCards_onTurnStarted,
        ],
        "elGringo": [
            .steal_offender_onDamaged,
            .drawDeck_startTurnCards_onTurnStarted,
        ],
        "suzyLafayette": [
            .drawDeck_onHandEmpty,
            .drawDeck_startTurnCards_onTurnStarted,
        ],
        "sidKetchum": [
            .discard_2_hand,
            .heal_1,
            .drawDeck_startTurnCards_onTurnStarted,
        ],
        "vultureSam": [
            .steal_all_onOtherEliminated,
            .drawDeck_startTurnCards_onTurnStarted,
        ],
        "kitCarlson": [
            .reveal_startTurnCardsPlus1,
            .chooseCard_startTurnCards
        ],
        "blackJack": [
            .drawDeck_startTurnCards_onTurnStarted,
            .revealLastDraw_onTurnStarted,
            .drawDeck_1_onTurnStarted_IfDrawsRed
        ]
    ]
}
 
