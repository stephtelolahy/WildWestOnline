// swiftlint:disable:this file_name
//  Tags.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 02/08/2024.
//
// swiftlint:disable identifier_name no_magic_numbers file_length

/// Defining Tags
/// ℹ️ Naming = {action}_{argValue}_on{Event}_if{Condition}
/// ⚠️ Before dispatching resolved action, verify initial event is still confirmed as state
extension Effect {
    // MARK: - Collectible - Action

    static var brown: Effect {
        .init(
            when: .played,
            action: .discardSilently,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var heal_ifPlayersAtLeast3: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .if(.playersAtLeast(3)),
                .arg(.healAmount, value: .value(1))
            ]
        )
    }

    static var heal_all: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .target(.all),
                .arg(.healAmount, value: .value(1))
            ]
        )
    }

    static var drawDeck_2: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ]
        )
    }

    static var drawDeck_3: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .repeat(.value(3))
            ]
        )
    }

    static var discard_any: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .chooseTarget([.havingCard]),
                .chooseCard()
            ]
        )
    }

    static var steal_atDistanceOf1: Effect {
        .init(
            when: .played,
            action: .steal,
            selectors: [
                .chooseTarget([.atDistance(.value(1)), .havingCard]),
                .chooseCard()
            ]
        )
    }

    static var shoot_reachable_bangLimitPerTurn: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .effectAttribute(.bangLimitPerTurn, value: 1),
                .effectAttribute(.bangRequiredMisses, value: 1),
                .effectAttribute(.bangDamage, value: 1),
                .if(.playedLessThan(.effectAttr(.bangLimitPerTurn))),
                .chooseTarget([.atDistance(.playerAttr(.weapon))]),
                .arg(.shootRequiredMisses, value: .effectAttr(.bangRequiredMisses)),
                .arg(.damageAmount, value: .effectAttr(.bangDamage))
            ]
        )
    }

    static var missed: Effect {
        .init(
            when: .played,
            action: .missed
        )
    }

    static var shoot_others: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .target(.others)
            ]
        )
    }

    static var damage_others_counterWithBang: Effect {
        .init(
            when: .played,
            action: .damage,
            selectors: [
                .target(.others),
                .chooseEventuallyCounterHandCard(.named("bang")),
                .arg(.damageAmount, value: .value(1))
            ]
        )
    }

    static var damage_any_reverseWithBang: Effect {
        .init(
            when: .played,
            action: .damage,
            selectors: [
                .chooseTarget(),
                .chooseEventuallyReverseHandCard(.named("bang")),
                .arg(.damageAmount, value: .value(1))
            ]
        )
    }

    static var reveal_activePlayers: Effect {
        .init(
            when: .played,
            action: .reveal,
            selectors: [
                .arg(.revealCount, value: .activePlayers)
            ]
        )
    }

    static var chooseCard_all: Effect {
        .init(
            when: .played,
            action: .chooseCard,
            selectors: [
                .target(.all),
                .chooseCard(.choosable)
            ]
        )
    }

    // MARK: - Collectible - Equipment

    static var equip: Effect {
        .init(
            when: .played,
            action: .equip,
            selectors: [
                .card(.played)
            ]
        )
    }

    static var draw_onShot: Effect {
        .init(
            when: .shot,
            action: .draw
        )
    }

    static var missed_onShot_ifDrawHearts: Effect {
        .init(
            when: .shot,
            action: .missed,
            selectors: [
                .if(.draw("♥️"))
            ]
        )
    }

    static var draw_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .draw
        )
    }

    static var pass_next_onTurnStarted_ifNotDrawSpades: Effect {
        .init(
            when: .turnStarted,
            action: .pass,
            selectors: [
                .if(.not(.draw("[2-9]♠️"))),
                .target(.next),
                .card(.played)
            ]
        )
    }

    static var damage_3_onTurnStarted_ifDrawSpades: Effect {
        .init(
            when: .turnStarted,
            action: .damage,
            selectors: [
                .if(.draw("[2-9]♠️")),
                .arg(.damageAmount, value: .value(3))
            ]
        )
    }

    static var discard_onTurnStarted_ifDrawSpades: Effect {
        .init(
            when: .turnStarted,
            action: .discard,
            selectors: [
                .if(.draw("[2-9]♠️")),
                .card(.played)
            ]
        )
    }

    static var setAttribute_weapon_1: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.weapon, value: 1)
            ]
        )
    }

    static var setAttribute_weapon_2: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.weapon, value: 2)
            ]
        )
    }

    static var setAttribute_weapon_3: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.weapon, value: 3)
            ]
        )
    }

    static var setAttribute_weapon_4: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.weapon, value: 4)
            ]
        )
    }

    static var setAttribute_weapon_5: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.weapon, value: 5)
            ]
        )
    }

    static var setAttribute_bangLimitPerTurn_0: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.bangLimitPerTurn, value: 0)
            ]
        )
    }

    static var incrementAttribute_magnifying: Effect {
        .init(
            when: .played,
            action: .incrementAttribute,
            selectors: [
                .playerAttribute(.magnifying, value: 1)
            ]
        )
    }

    static var incrementAttribute_remoteness: Effect {
        .init(
            when: .played,
            action: .incrementAttribute,
            selectors: [
                .playerAttribute(.remoteness, value: 1)
            ]
        )
    }

    // MARK: - Collectibles - Handicap

    static var handicap: Effect {
        .init(
            when: .played,
            action: .handicap,
            selectors: [
                .chooseTarget(),
                .card(.played)
            ]
        )
    }

    static var endTurn_onTurnStarted_ifNotDrawHearts: Effect {
        .init(
            when: .turnStarted,
            action: .endTurn,
            selectors: [
                .if(.not(.draw("♥️")))
            ]
        )
    }

    static var discard_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .discard,
            selectors: [
                .card(.played)
            ]
        )
    }

    // MARK: - Abilities

    static var endTurn: Effect {
        .init(
            when: .played,
            action: .endTurn
        )
    }

    static var discard_excessHand: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .repeat(.excessHand),
                .chooseCard()
            ]
        )
    }

    static var startTurn_next_onTurnEnded: Effect {
        .init(
            when: .turnEnded,
            action: .startTurn,
            selectors: [
                .target(.next)
            ]
        )
    }

    static var drawDeck_startTurnCards_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .effectAttribute(.startTurnCards, value: 2),
                .repeat(.effectAttr(.startTurnCards))
            ]
        )
    }

    static var eliminate_onDamageLethal: Effect {
        .init(
            when: .damagedLethal,
            action: .eliminate
        )
    }

    static var discard_all_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .discard,
            selectors: [
                .card(.all)
            ]
        )
    }

    static var endTurn_onEliminated: Effect {
        .init(
            when: .eliminated,
            action: .endTurn,
            selectors: [
                .if(.actorTurn)
            ]
        )
    }

    static var discard_previousWeapon_onWeaponPlayed: Effect {
        .init(
            when: .cardPlayedWithAttr(.weapon),
            action: .discard,
            selectors: [
                .card(.inPlayWithAttr(.weapon))
            ]
        )
    }

    static var play_missed_onShot: Effect {
        .init(
            when: .shot,
            action: .play,
            selectors: [
                .chooseEventuallyCard(.action(.missed))
            ]
        )
    }

    static var play_beer_onDamagedLethal: Effect {
        .init(
            when: .damagedLethal,
            action: .play,
            selectors: [
                .if(.playersAtLeast(3)),
                .chooseEventuallyCard(.named("beer"))
            ]
        )
    }

    // MARK: - Figures

    static var drawDeck_onDamaged: Effect {
        .init(
            when: .damaged,
            action: .drawDeck,
            selectors: [
                .repeat(.lastDamage)
            ]
        )
    }

    static var steal_offender_onDamaged: Effect {
        .init(
            when: .damaged,
            action: .steal,
            selectors: [
                .target(.offender),
                .repeat(.lastDamage)
            ]
        )
    }

    static var drawDeck_onHandEmpty: Effect {
        .init(
            when: .handEmpty,
            action: .drawDeck
        )
    }

    static var heal_cost2HandCards: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .chooseCostHandCard(count: 2),
                .arg(.healAmount, value: .value(1))
            ]
        )
    }

    static var steal_all_onOtherEliminated: Effect {
        .init(
            when: .otherEliminated,
            action: .steal,
            selectors: [
                .target(.eliminated),
                .card(.all)
            ]
        )
    }

    static var reveal_3_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .reveal,
            selectors: [
                .arg(.revealCount, value: .value(3))
            ]
        )
    }

    static var chooseCard_2_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .chooseCard,
            selectors: [
                .repeat(.value(3))
            ]
        )
    }

    static var showLastDraw_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .showLastDraw
        )
    }

    static var drawDeck_onTurnStarted_IfDrawsRed: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .if(.draw("(♥️)|(♦️)"))
            ]
        )
    }

    static var drawDiscard_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDiscard
        )
    }

    static var steal_any_fromHand_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .steal,
            selectors: [
                .chooseTarget([.havingHandCard]),
                .chooseCard()
            ]
        )
    }

    static var setAttribute_bangRequiredMisses_2: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.bangRequiredMisses, value: 2)
            ]
        )
    }

    static var setAttribute_maxHealth_4: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.maxHealth, value: 4)
            ]
        )
    }

    static var setAttribute_maxHealth_3: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.maxHealth, value: 3)
            ]
        )
    }

    static var setAttribute_drawCards_2: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.drawCards, value: 2)
            ]
        )
    }

    static var setAttribute_drawCards_1: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.drawCards, value: 1)
            ]
        )
    }

    static var setAttribute_playBangWithMissed: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.playBangWithMissed, value: 0)
            ]
        )
    }

    static var setAttribute_playMissedWithBang: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.playMissedWithBang, value: 0)
            ]
        )
    }

    // MARK: - Dodge city

    static var shoot_atDistanceOf1: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.atDistance(.value(1))])
            ]
        )
    }

    static var drawDeck: Effect {
        .init(
            when: .played,
            action: .drawDeck
        )
    }

    static var shoot_any_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseCostHandCard(),
                .chooseTarget()
            ]
        )
    }

    static var heal_2_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .chooseCostHandCard(),
                .arg(.healAmount, value: .value(2))
            ]
        )
    }

    static var heal_any_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .chooseCostHandCard(),
                .chooseTarget(),
                .arg(.healAmount, value: .value(1))
            ]
        )
    }

    static var steal_any_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .steal,
            selectors: [
                .chooseCostHandCard(),
                .chooseTarget(),
                .chooseCard()
            ]
        )
    }

    static var discard_all_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .chooseCostHandCard(),
                .target(.all),
                .chooseCard()
            ]
        )
    }

    static var setAttribute_playMissedWithAny: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.playMissedWithAny, value: 0)
            ]
        )
    }

    static var setAttribute_handLimit_10: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.handLimit, value: 10)
            ]
        )
    }

    static var heal_onBeerPlayed: Effect {
        .init(
            when: .cardPlayedWithName("beer"),
            action: .heal
        )
    }

    static var setAttribute_startTurnCards_3: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.startTurnCards, value: 3)
            ]
        )
    }

    static var setAttribute_startTurnCards_1: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.startTurnCards, value: 1)
            ]
        )
    }

    static var setAttribute_startTurnCards_0: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.startTurnCards, value: 0)
            ]
        )
    }

    static var drawDeck_damage_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .repeat(.damage)
            ]
        )
    }

    static var heal_2_onOtherEliminated: Effect {
        .init(
            when: .otherEliminated,
            action: .heal,
            selectors: [
                .arg(.healAmount, value: .value(2))
            ]
        )
    }

    static var drawDeck_2_onOtherEliminated: Effect {
        .init(
            when: .otherEliminated,
            action: .drawDeck,
            selectors: [
                .repeat(.value(2))
            ]
        )
    }

    static var drawDeck_onPlayedCardOutOfTurn: Effect {
        .init(
            when: .playedCardOutOfTurn,
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2)))
            ]
        )
    }

    static var drawDeck_2_costBlueHandCard: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .if(.playedLessThan(.value(2))),
                .chooseCostHandCard(.isBlue),
                .repeat(.value(2))
            ]
        )
    }

    static var drawDeck_2_cost1LifePoint: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .chooseEventuallyLooseLifePoint,
                .repeat(.value(2))
            ]
        )
    }

    static var shoot_reachable_cost2HandCards: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .if(.playedLessThan(.value(1))),
                .chooseCostHandCard(count: 2),
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
            ]
        )
    }

    static var steal_any_inPlay_onTurnStarted: Effect {
        .init(
            when: .turnStarted,
            action: .steal,
            selectors: [
                .chooseTarget([.havingInPlayCard]),
                .chooseCard(.inPlay)
            ]
        )
    }

    static var setAttribute_silentCardsDiamonds: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.silentCardsDiamonds, value: 0)
            ]
        )
    }

    static var setAttribute_silentCardsInPlayDuringTurn: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.silentCardsInPlayDuringTurn, value: 0)
            ]
        )
    }

    // MARK: - The Valley of Shadows

    static var heal: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .arg(.healAmount, value: .value(1))
            ]
        )
    }

    static var drawDeck_all_2_cost1HandCard: Effect {
        .init(
            when: .played,
            action: .drawDeck,
            selectors: [
                .target(.all),
                .chooseCostHandCard(),
                .repeat(.value(2))
            ]
        )
    }

    static var shoot_reachable: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.atDistance(.playerAttr(.weapon))])
            ]
        )
    }

    static var shoot_atDistanceOf2: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.atDistance(.value(2))])
            ]
        )
    }

    static var shoot_neighbour: Effect {
        .init(
            when: .played,
            action: .shoot,
            selectors: [
                .chooseTarget([.neighbourToTarget])
            ]
        )
    }

    static var play_onOtherDamaged: Effect {
        .init(
            when: .otherDamaged,
            action: .play,
            selectors: [
                .chooseEventuallyCard(.named("saved"))
            ]
        )
    }

    static var heal_lastDamaged: Effect {
        .init(
            when: .played,
            action: .heal,
            selectors: [
                .target(.damaged)
            ]
        )
    }

    static var damage_others_counterWith2HandCards: Effect {
        .init(
            when: .played,
            action: .damage,
            selectors: [
                .target(.others),
                .chooseEventuallyCounterHandCard(count: 2),
                .arg(.damageAmount, value: .value(1))
            ]
        )
    }

    static var discard_others: Effect {
        .init(
            when: .played,
            action: .discard,
            selectors: [
                .target(.others),
                .chooseCard()
            ]
        )
    }

    static var drawDiscard_2_ifDiscardedCardsNotAce: Effect {
        .init(
            when: .played,
            action: .drawDiscard,
            selectors: [
                .if(.discardedCardsNotAce),
                .repeat(.value(2))
            ]
        )
    }

    static var setAttribute_playBangWithAny: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .playerAttribute(.playBangWithAny, value: 0)
            ]
        )
    }

    static var discard_anyHand_onDamagingWithBang: Effect {
        .init(
            when: .damagingWith("bang"),
            action: .discard,
            selectors: [
                .target(.damaged),
                .chooseCard(.fromHand)
            ]
        )
    }

    static var play_onBangPlayed: Effect {
        .init(
            when: .cardPlayedWithName("bang"),
            action: .play,
            selectors: [
                .chooseEventuallyCard(.named("aim"))
            ]
        )
    }

    static var setAttribute_bangDamage_2: Effect {
        .init(
            when: .played,
            action: .setAttribute,
            selectors: [
                .effectAttribute(.bangDamage, value: 2)
            ]
        )
    }

    static var drawDeck_offender_onDamagedWithBang: Effect {
        .init(
            when: .damagedWith("bang"),
            action: .drawDeck,
            selectors: [
                .target(.offender)
            ]
        )
    }

    static var damage_onTurnStarted_ifDrawSpades: Effect {
        .init(
            when: .turnStarted,
            action: .damage,
            selectors: [
                .if(.draw("♠️")),
                .arg(.damageAmount, value: .value(1))
            ]
        )
    }

    static var drawDeck_2_onTurnStarted_ifHasNoBlueCardsInPlay: Effect {
        .init(
            when: .turnStarted,
            action: .drawDeck,
            selectors: [
                .if(.hasNoBlueCardsInPlay)
            ]
        )
    }

    static var draw_onMissedBang: Effect {
        .init(
            when: .missed("bang"),
            action: .draw
        )
    }

    static var damage_target_onMissedBang_ifDrawSpades: Effect {
        .init(
            when: .missed("bang"),
            action: .damage,
            selectors: [
                .if(.draw("♠️")),
                .target(.targeted),
                .arg(.damageAmount, value: .value(1))
            ]
        )
    }

    static var heal_onOtherPlayedBeer_cost1HandCard: Effect {
        .init(
            when: .otherPlayedCardWithName("beer"),
            action: .heal,
            selectors: [
                .chooseCostHandCard(),
                .arg(.healAmount, value: .value(1))
            ]
        )
    }
}
