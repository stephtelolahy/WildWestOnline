// The Swift Programming Language
// https://docs.swift.org/swift-book

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
///
typealias Card = [CardEffect]

public enum Cards {
    static let all: [String: Card] = [
        // MARK: - Bang

        "beer": [
            .discardSilently,
            .heal_ifPlayersAtLeast3
        ],
        "saloon": [
            .discardSilently,
            .heal_all
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
            .setAttribute_weapon_2
        ],
        "remington": [
            .equip,
            .setAttribute_weapon_3
        ],
        "revCarabine": [
            .equip,
            .setAttribute_weapon_4
        ],
        "winchester": [
            .equip,
            .setAttribute_weapon_5
        ],
        "volcanic": [
            .equip,
            .setAttribute_weapon_1,
            .setAttribute_bangLimitPerTurn_0
        ],
        "scope": [
            .equip,
            .incrementAttribute_magnifying
        ],
        "mustang": [
            .equip,
            .incrementAttribute_remoteness
        ],
        "jail": [
            .handicap,
            .draw_onTurnStarted,
            .endTurn_onTurnStarted_ifNotDrawHearts,
            .discard_onTurnStarted
        ],
        "finishTurn": [
            .endTurn,
            .discard_excessHand
        ],
        "default": [
            .setAttribute_weapon_1,
            .setAttribute_startTurnCards_2,
            .setAttribute_bangLimitPerTurn_1,
            .setAttribute_drawCards_1,
            .drawDeck_startTurnCards_onTurnStarted,
            .startTurn_next_onTurnEnded,
            .eliminate_onDamageLethal,
            .discard_all_onEliminated,
            .endTurn_onEliminated,
            .discard_previousWeapon_onWeaponPlayed,
            .play_missed_onShot,
            .play_beer_onDamagedLethal
        ],
        "willyTheKid": [
            .setAttribute_bangLimitPerTurn_0
        ],
        "roseDoolan": [
            .incrementAttribute_magnifying
        ],
        "paulRegret": [
            .incrementAttribute_remoteness
        ],
        "jourdonnais": [
            .draw_onShot,
            .missed_onShot_ifDrawHearts
        ],
        "bartCassidy": [
            .drawDeck_onDamaged
        ],
        "elGringo": [
            .steal_offender_onDamaged
        ],
        "suzyLafayette": [
            .drawDeck_onHandEmpty
        ],
        "sidKetchum": [
            .heal_cost2HandCards
        ],
        "vultureSam": [
            .steal_all_onOtherEliminated
        ],
        "slabTheKiller": [
            .setAttribute_maxHealth_4,
            .setAttribute_bangAdditionalRequiredMisses_1
        ],
        "luckyDuke": [
            .setAttribute_maxHealth_4,
            .setAttribute_drawCards_2
        ],
        "calamityJanet": [
            .setAttribute_bangWithMissedAndViceVersa
        ],
        "kitCarlson": [
            // ⚠️ special startTurn
            .reveal_startTurnCardsPlus1,
            .chooseCard_startTurnCards
        ],
        "blackJack": [
            // ⚠️ special startTurn
            .revealLastDraw_onTurnStarted,
            .drawDeck_onTurnStarted_IfDrawsRed
        ],
        "jesseJones": [
            // ⚠️ special startTurn
            .drawDiscard_onTurnStarted,
            .drawDeck_startTurnCardsMinus1_onTurnStarted
        ],
        "pedroRamirez": [
            // ⚠️ special startTurn
            .steal_any_onTurnStarted,
            .drawDeck_startTurnCardsMinus1_onTurnStarted
        ],

        // MARK: - Dodge city

        "punch": [
            .discardSilently,
            .shoot_atDistanceOf1
        ],
        "dodge": [
            .discardSilently,
            .missed,
            .drawDeck
        ],
        "springfield": [
            .discardSilently,
            .shoot_any_cost1HandCard
        ],
        "hideout": [
            .equip,
            .incrementAttribute_remoteness
        ],
        "binocular": [
            .equip,
            .incrementAttribute_magnifying
        ],
        "whisky": [
            .discardSilently,
            .heal_2_cost1HandCard
        ],
        "tequila": [
            .discardSilently,
            .heal_any_cost1HandCard
        ],
        "ragTime": [
            .discardSilently,
            .steal_any_cost1HandCard
        ],
        "brawl": [
            .discardSilently,
            .discard_all_cost1HandCard
        ],
        "elenaFuente": [
            .setAttribute_missedWithAnyCard
        ]
    ]
}
